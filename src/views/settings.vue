<script setup>
// =============================
//          Import
import axios from "axios";
import { ref, onMounted, inject, watch } from "vue";
import { useToast } from "primevue/usetoast";
import { useConfirm } from "primevue/useconfirm";
import IndexedDBService from './../services/IndexedDBService'

// ============================= 
//          Const

// GLOBAL
const toast = useToast();
const confirm = useConfirm();
const loading = ref(false)

// USER 
const user = inject('user')
const groups = ref(inject('groups'));
const group = ref(null)
const selectedGroup = inject('selectedGroup')

// CHANGE SELECTED GROUP
const changeSelectedGroup = () => {
  group.value = selectedGroup.data.value
} 
watch(() => selectedGroup.data.value, changeSelectedGroup);
const admin = inject('isAdmin')
const isAdmin = ref(false)
// CHANGE ADMIN VALUE
const changeAdmin = () => {
  isAdmin.value = admin.data.value
}
watch(() => admin.data.value, changeAdmin);

// NEW GROUP DIALOG
const visible = ref(false)
const groupName = ref("")
const startAmount = ref(null)
const vlan = ref("")
  // New group invalid
const invalidGroupName = ref(false)
const invalidGroupVlan = ref(false)

// CHANGE MEMBERS DIALOG
const changeVisible = ref(false)
const users = ref("")
const usersList = ref([])
const userRightsVisible = ref(false)
const nameUserRights = ref()

// RIGHTS
const teacher = ref(false)
const rights = ref([])
const selectedRights = ref([])
const userIdRights = ref()

// CHANGE SPRINT PERIODS
const visibleSprintPeriods = ref(false)
const sprints = ref(null)

// CHANGE TELEGRAM CHAT ID
const visibleChangeTelegram = ref(false)
const visibleChangeTelegramAlert = ref(false)
const chatId = ref(null)
const alertChatId = ref(null)

// CHANGE VLAN
const visibleChangeVlan = ref(false)

// Salary
const visibleSalary = ref(false)
const salary1 = ref()
const salary2 = ref()



// =============================
//          Functions

// CREATE NEW GROUP
const createGroup = () => {
  if(groupName.value.length < 4 || vlan.value.length == 0) {
    if(groupName.value.length < 4) {
      invalidGroupName.value = true
    }
    if(vlan.value.length == 0) {
      invalidGroupVlan.value = true
    }
    toast.add({ severity: 'error', summary: 'Invalid Group Name!', detail: 'The group name should have at least 4 characters.', life: 4000 });
  }else{
    invalidGroupName.value = false
      invalidGroupVlan.value = false
    let newGroupData = { 
      token: window.$cookies.get("auth"), 
      name: groupName.value, 
      amount: startAmount.value,  
      users: users.value,
      vlan: vlan.value
    }
    loading.value = true;
    axios.post(import.meta.env.VITE_APP_BACKEND_IP + '/settings/createGroup', newGroupData )
      .then((res) => {
        if(res.data.ok){
          // Refrescar groups
          users.value = ""
          toast.add({ severity: 'success', summary: 'Created Correclty!', detail: 'Group Created Correctly.', life: 4000 });
          visible.value = false
          // Rigths
          res.data.rights.forEach((right) => {
            IndexedDBService.agregarDato({"rights": [right.right_id], groupId: right.group_id})
          })
          groups.value.updateGroups()
        }else{
          toast.add({ severity: 'error', summary: 'Error!', detail: 'Error creating the group.', life: 4000 });
        }
        loading.value = false;
      })
  }
}

// CHANGE MEMBERS
const changeMembers = () => {
  loading.value = true
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/settings/changeMembers', { params: { token: window.$cookies.get("auth"), groupId: group.value.id, users: users.value } })
    .then((res) => {
      if(res.data){
        users.value = ""
        loading.value = false
        openChangeMembers()
        toast.add({ severity: 'success', summary: 'Added Users!', detail: 'Correclty added users.', life: 4000 });
      }else{
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error adding users.', life: 4000 });
      }
    })
}

// CONFIRM QUIT USERS
const confirmQuitUser = (id) => {
  confirm.require({
    message: 'Are you sure you want to proceed?',
    header: 'Confirmation',
    icon: 'pi pi-exclamation-triangle',
    accept: () => {
      loading.value = true;
      axios.delete(import.meta.env.VITE_APP_BACKEND_IP + '/settings/quitUser', {params: {groupId: group.value.id, userId: id}})
        .then((res) => {
          if(res.data){
            openChangeMembers()
            toast.add({ severity: 'success', summary: 'Confirmed!', detail: 'User has been quited.', life: 3000 });
          }else {
            toast.add({ severity: 'error', summary: 'Error!', detail: 'An error occurred while quitting the user. Try it again.', life: 3000 });
          }
          loading.value = false;
        })
    },
    reject: () => {
      toast.add({ severity: 'warn', summary: 'Cancelled!', detail: 'User hasn\'t been quited.', life: 3000 });
    }
  });
}

// OPEN CHANGE MEMBERS DIALOG
const openChangeMembers = () => {
  if(group.value == null){
    toast.add({ severity: 'warn', summary: 'No group selected!', detail: 'Please, select a group to manage it.', life: 3000 });
  }else{ 
    changeVisible.value = true
    loading.value = true;
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/settings/getUsers', { params: { groupId: group.value.id } } )
      .then((res) => {
        if(res.data.ok){
          // posar els users amb una v-for o posar els usuaris en una llista, depen del component (slotProps.item)
          // console.log(res.data.users)
          usersList.value = res.data.users
        }else{
          toast.add({ severity: 'error', summary: 'Error!', detail: 'An error occurred while getting users. Try it again.', life: 3000 });
        }
        loading.value = false;
      })
  }
}

// DLETE GROUP CONFIRMATION
const openDeleteGroup = () => {
  if(group.value == null){
    toast.add({ severity: 'warn', summary: 'No group selected!', detail: 'Please, select a group to manage it.', life: 3000 });
  }else {
    confirm.require({
      message: 'Are you sure you want to proceed?',
      header: 'Confirmation',
      icon: 'pi pi-exclamation-triangle',
      accept: () => {
        loading.value = true;
        axios.delete(import.meta.env.VITE_APP_BACKEND_IP + '/settings/deleteGroup', {params: {groupId: group.value.id}})
          .then((res) => {
            if(res.data){
              // Refrescar groups
              toast.add({ severity: 'success', summary: 'Confirmed!', detail: 'Group has been deleted.', life: 3000 });
              groups.value.updateGroups()
            }else {
              toast.add({ severity: 'error', summary: 'Error!', detail: 'An error occurred while deleting the group. Try it again.', life: 3000 });
            }
            loading.value = false;
          })
      },
      reject: () => {
        toast.add({ severity: 'warn', summary: 'Cancelled!', detail: 'Group hasn\'t been deleted.', life: 3000 });
      }
    });
  }
}

const getRights = async () => {
  let rights = await IndexedDBService.obtenerDatos(0)
  if(rights != undefined){
    if(rights.rights.includes(2, 0)) {
      teacher.value = true
    } else {
      teacher.value = false
    }
  } else {
    teacher.value = false
  }
}

const openChangeSprintPeriods = () => {
  visibleSprintPeriods.value = true 
  loading.value = true
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/settings/getSprints')
    .then((res) => {
      loading.value = false
      if(res.data.ok) {
        sprints.value = res.data.sprints
      }
    })
}

const saveSprintPeriods = () => {
  // console.log(sprints.value)
  loading.value = true
  axios.post(import.meta.env.VITE_APP_BACKEND_IP + '/settings/updateSprints', sprints.value) 
    .then((res) => {
      loading.value = false
      if(res.data){
        toast.add({ severity: 'success', summary: 'Saved!', detail: 'Sprints has been saved.', life: 3000 });
        openChangeSprintPeriods()
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Sprints hasn\'t been saved.', life: 3000 });
      }
    })
}

const openChangeRights = (userId, name) => {
  getAllRights(userId)
  userRightsVisible.value = true
  nameUserRights.value = name
  userIdRights.value = userId
}

const getAllRights = (userId) => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + "/settings/getRights") 
    .then((res) => {
      if(res.data.ok) {
        rights.value = res.data.rights;
        selectedRights.value = []
        usersList.value.forEach((user) => {
          if(user.id == userId) {
            rights.value.forEach((right) => {
              if(user.rights.includes(parseInt(right.id))){
                selectedRights.value.push(right.id)
              }
            })
            // break
            return;
          }
        })
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the rights.', life: 3000 });
      }
    })
}

const saveUserRights = () => {
  let object = {user_id: userIdRights.value, group_id: group.value.id, rights_id: selectedRights.value}
  axios.post(import.meta.env.VITE_APP_BACKEND_IP + "/settings/saveRights", object)
    .then((res) => {
      if(res.data){
        userRightsVisible.value = false
        toast.add({ severity: 'success', summary: 'Saved!', detail: 'The rights have been saved.', life: 3000 });
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error saving the rights.', life: 3000 });
      }
    })
}

const getChatId = () => {
  if(chatId.value == null) {
    axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/settings/getChatId")
      .then((res) => {
        if(res.data.ok) {
          // console.log(res.data.chatId)
          chatId.value = res.data.chatId
        }else {
          toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the Chat ID.', life: 3000 });
        }
      })
  }
}

const saveChatId = () => {
  if(chatId.value != null && chatId.value != ""){
    axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/settings/saveChatId", chatId.value)
      .then((res) => {
        if(res.data) {
          toast.add({ severity: 'success', summary: 'Saved!', detail: 'Chat ID saved successfully.', life: 3000 });
        }else {
          toast.add({ severity: 'error', summary: 'Error!', detail: 'Error saving the Chat ID.', life: 3000 });
        }
      })
      .catch((err) => {
        console.error(err)
      })
  }
}
const getAlertChatId = () => {
  if(alertChatId.value == null) {
    axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/settings/getAlertChatId")
      .then((res) => {
        if(res.data.ok) {
          // console.log(res.data.chatId)
          alertChatId.value = res.data.chatId
        }else {
          toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the Chat ID.', life: 3000 });
        }
      })
  }
}

const saveAlertChatId = () => {
  if(alertChatId.value != null && alertChatId.value != ""){
    axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/settings/saveAlertChatId", alertChatId.value)
      .then((res) => {
        if(res.data) {
          toast.add({ severity: 'success', summary: 'Saved!', detail: 'Chat ID saved successfully.', life: 3000 });
          visibleChangeTelegramAlert.value = false
        }else {
          toast.add({ severity: 'error', summary: 'Error!', detail: 'Error saving the Chat ID.', life: 3000 });
        }
      })
      .catch((err) => {
        console.error(err)
      })
  }
}

const getVlan = () => {
  vlan.value = ""
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/settings/getVlan", {params: {id: group.value.id}})
    .then((res) => {
      if(res.data.ok) {
        vlan.value = res.data.vlan
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the group Vlan.', life: 3000 });
      }
    })
}

const saveVlan = () => {
  axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/settings/saveVlan", {groupId: group.value.id, vlan: vlan.value})
    .then((res) => {
      if(res.data) {
        toast.add({ severity: 'success', summary: 'Saved!', detail: 'Vlan saved successfully.', life: 3000 });
        visibleChangeVlan.value = false
      } else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error saving the Vlan.', life: 3000 });
      }
    })
}

const getSalary = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/settings/getSalary")
    .then((res) => {
      if(res.data.ok) {
        salary1.value = res.data.firstCourse
        salary2.value = res.data.secondCourse
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the prices.', life: 3000 })
      }
    })
  // salary1.value = 4.0
  // salary2.value = 6.0
}

const saveSalary = () => {

}

// ON MOUNTED
onMounted(() => {
  document.title = "Settings"
  group.value = selectedGroup.data.value
  isAdmin.value = admin.data.value
  getRights()
})

</script>

<template>
  <div class="card ml-8 mr-8 pl-8 pr-8 pt-4">
    <Card class="ml-8 mr-8 pl-8 pr-8 pt-4 pb-6">
      <!-- SETTINGS TITLE -->
      <template #title>
        <div class="flex align-items-center mt-2">
          <i class="pi pi-cog mr-2" style="font-size: 2rem"></i>
          Settings 
        </div>
      </template>
      <!-- SETTINGS CONTENT -->
      <template #content>
        <div class="pl-8 pr-8">
          <!-- CHANGE GROUP -->
          <!-- <div class="flex justify-content-between align-items-center">
            <div class="flex align-items-center">
              <i class="pi pi-arrow-right-arrow-left" style="font-size: 1.3rem"></i>
              <span class="ml-2">Change group</span>
            </div>
            <Dropdown @change="changeGroup()" v-model="group" :options="groups.data" optionLabel="name" placeholder="Select a Group" class="w-full md:w-14rem" />
          </div> -->

          
          <Divider/>

          
          <!-- GROUP SETTINGS -->
          <div id="groupSettings">
            <div class="flex align-items-center">
                <h3>Group Settings</h3>
            </div>
            <!-- CHANGE MEMBERS -->
            <div class="ml-6">
              <div class="flex justify-content-between align-items-center">
                <div class="flex align-items-center">
                  <i class="pi pi-users" style="font-size: 2rem"></i>
                  <span class="ml-2">Change members</span>
                </div>
                <Button @click="openChangeMembers()" label="Change" />
  
                <Dialog v-model:visible="changeVisible" modal :closable="false" :style="{ width: '35rem', maxHeight: '70vh' }" 
                :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
                <!-- HEADER DIALOG NEW GROUP -->
                <template #header>
                  <div class="flex align-items-center">
                    <i class="pi pi-users" style="font-size: 1.5rem"></i>
                    <b class="text-2xl ml-2">Change Members</b>
                  </div>
                </template>
                <!-- CONTENT DIALOG NEW GROUP -->
                <div class="mt-4">
                  <!-- LIST MEMBERS -->
                  <DataView :value="usersList" scrollable >
                    <template #list="slotProps">
                      <div class="grid grid-nogutter">
                        <div v-for="(item, index) in slotProps.items" :key="index" class="col-12">
                          <div class="flex flex-column xl:flex-row xl:align-items-center pl-4 pr-4 pt-2 pb-2 gap-4" :class="{ 'border-top-1 surface-border': index !== 0 }">
                            <i class="pi pi-user" style="font-size: 2rem"></i>
                            <div class="flex flex-column sm:flex-row justify-content-between align-items-center flex-1 gap-4">
                              <div class="">{{ item.name }}</div>
                              <div class="flex align-items-center sm:align-items-end gap-3 sm:gap-2">
                                <Button v-if="isAdmin || teacher" icon="pi pi-book p-0" @click="openChangeRights(item.id, item.name)" rounded label="Rights"></Button>
                                <Button v-if="isAdmin || teacher" icon="pi pi-times p-0" @click="confirmQuitUser(item.id)" rounded :disabled="item.id===group.admin_id"></Button>
                                
                                <!-- USER RIGHTS DIALOG -->
                                <Dialog v-model:visible="userRightsVisible" modal :closable="false" :style="{ width: '35rem', maxHeight: '70vh' }" 
                                  :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
                                  <template #header>
                                    <div class="flex align-items-center">
                                      <i class="pi pi-book" style="font-size: 1.5rem"></i>
                                      <b class="text-2xl ml-2">Change {{ nameUserRights }}'s Rights</b>
                                    </div>
                                  </template>
                                  
                                  <div class="card flex justify-content-center">
                                    <div class="flex flex-column gap-3 card shadow-4 p-4 border-round">
                                      <div v-for="right of rights" :key="right.id" class="flex align-items-center">
                                        <Checkbox v-model="selectedRights" :inputId="right.id" name="right" :value="right.id" />
                                        <label :for="right.name" class="ml-2">{{ right.name }}</label>
                                      </div>
                                    </div>
                                  </div>

                                  <template #footer>
                                    <!-- ADD MEMBER -->
                                    <div class="flex justify-content-center w-full gap-3">
                                      <Button label="Cancel" icon="pi pi-times" @click="userRightsVisible = false; rights = []" class="surface-300 border-400 text-black-alpha-90"/>
                                      <Button label="Save" icon="pi pi-upload" @click="saveUserRights" class=""/>
                                    </div>
                                  </template>
                                </Dialog>
                                <!-- END USER RIGHTS DIALOG -->

                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </template>
                  </DataView>
                </div>
                <!-- FOOTER DIALOG NEW GROUP -->
                <template #footer>
                  <!-- ADD MEMBER -->
                  <div v-if="isAdmin || teacher" class="card flex align-items-center mt-2">
                    <span class="col-9 p-float-label">
                      <InputText v-model="users" class="w-full" placeholder="marc, lluc..." />
                      <label class="pl-2" for="users">Username</label>
                    </span>
                    <Button label="Submit" icon="pi pi-upload" @click="changeMembers()" class="col-3 bg-green-500 border-green-600"/>
                  </div>
                  <div class="flex justify-content-center">
                    <Button label="Cancel" icon="pi pi-times" @click="changeVisible = false" class="surface-300 border-400 text-black-alpha-90"/>
                  </div>
                </template>
              </Dialog>
              </div> 
            </div><!-- fi change members -->

            <!-- CHANGE VLAN -->
            <div class="ml-6 flex justify-content-between align-items-center mt-4">
              <div class="flex align-items-center">
                <i class="pi pi-sitemap" style="font-size: 2rem"></i>
                <span class="ml-2">Change VLAN</span>
              </div>
              <Button @click="visibleChangeVlan=true; getVlan();" label="Change" />
              <!-- DIALOG VLAN -->
              <Dialog v-model:visible="visibleChangeVlan" modal :closable="false" :style="{ width: '30rem' }" 
                :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
                <!-- HEADER DIALOG VLAN -->
                <template #header>
                  <div class="flex align-items-center">
                    <i class="pi pi-sitemap" style="font-size: 1.5rem"></i>
                    <b class="text-2xl ml-2">Change VLAN</b>
                  </div>
                </template>
                <!-- CONTENT DIALOG VLAN -->
                <div class="mt-4">
                  <!-- GROUP NAME & STRATING AMOUNT -->
                  <span class="col-12 p-float-label">
                    <InputText v-model="vlan" class="w-full" />
                    <label class="pl-2" for="chatId">VLAN</label>
                  </span>
                </div>
                <!-- FOOTER DIALOG VLAN -->
                <template #footer>
                  <div class="flex justify-content-center w-full gap-3">
                    <Button label="Cancel" icon="pi pi-times" @click="visibleChangeVlan = false" class="surface-300 border-400 text-black-alpha-90"/>
                    <Button label="Submit" icon="pi pi-upload" @click="saveVlan()" class="bg-green-500 border-green-600"/>
                  </div>
                </template>
              </Dialog>
            </div><!-- FI VLAN -->


            <!-- DELETE GROUP -->
            <div v-if="isAdmin || teacher" class="ml-6 mt-4">
              <div class="flex justify-content-between align-items-center">
                <div class="flex align-items-center">
                  <i class="pi pi-trash" style="font-size: 2rem"></i>
                  <span class="ml-2">Delete Group</span>
                </div>
                <Button @click="openDeleteGroup()" label="Delete" />
  
              </div> 
            </div> <!-- FI DELETE GROUP -->

          </div> <!-- FI GROUP SETTINGS -->

          <Divider/>


          <!-- GLOBAL SETTINGS -->
          <div v-if="teacher" id="groupSettings">
            <div class="flex align-items-center">
                <h3>Global Settings</h3>
            </div>
            <!-- CHANGE SPRINT PERIODS -->
            <div class="ml-6">
              <div class="flex justify-content-between align-items-center">
                <div class="flex align-items-center">
                  <i class="pi pi-calendar" style="font-size: 2rem"></i>
                  <span class="ml-2">Change Sprint Periods</span>
                </div>
                <Button @click="openChangeSprintPeriods()" label="Change" />
  

                <Dialog v-model:visible="visibleSprintPeriods" modal :closable="false" :style="{ width: '35rem', maxHeight: '70vh' }" 
                :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
                <!-- HEADER DIALOG SPRINT PERIODS -->
                <template #header>
                  <div class="flex align-items-center">
                    <i class="pi pi-users" style="font-size: 1.5rem"></i>
                    <b class="text-2xl ml-2">Change Sprint Periods</b>
                  </div>
                </template>
                <!-- CONTENT DIALOG SPRINT PERIODS -->
                <div class="mt-4">
                  <!-- LIST SPRINTS -->
                  <DataView :value="sprints" scrollable >
                    <template #list="slotProps">
                      <div class="grid grid-nogutter">
                        <div v-for="(item, index) in slotProps.items" :key="index" class="col-12">
                          <div class="flex flex-column xl:flex-row xl:align-items-center pl-4 pr-4 pt-2 pb-2 gap-4" :class="{ 'border-top-1 surface-border': index !== 0 }">
                            <i class="pi pi-stopwatch" style="font-size: 2rem"></i>
                            <div class="flex flex-column sm:flex-row justify-content-between align-items-center flex-1 gap-4">
                              <div class="">{{ item.name }}</div>
                              <div class="flex sm:flex-column align-items-center sm:align-items-end gap-3 sm:gap-2">
                                <!-- <Button v-if="isAdmin" icon="pi pi-times p-0" @click="confirmQuitUser(item.id)" rounded :disabled="item.id===group.admin_id"></Button> -->
                                <Calendar v-model="item.date" dateFormat="yy-mm-dd" :utc="true" />
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </template>
                  </DataView>
                </div>
                <!-- FOOTER DIALOG NEW GROUP -->
                <template #footer>
                  <div class="flex justify-content-center w-full gap-3">
                    <Button label="Cancel" icon="pi pi-times" @click="visibleSprintPeriods = false" class="surface-300 border-400 text-black-alpha-90"/>
                    <Button label="Save" icon="pi pi-save" @click="saveSprintPeriods()" class="col-3 bg-green-500 border-green-600"/>
                  </div>
                </template>
              </Dialog>


              </div> 
            </div><!-- fi change members -->

            <!-- CHANGE SALARY -->
            <div class="ml-6 flex justify-content-between align-items-center mt-4">
              <div class="flex align-items-center">
                <i class="pi pi-euro" style="font-size: 2rem"></i>
                <span class="ml-2">Change Salary</span>
              </div>
              <Button @click="visibleSalary=true; getSalary();" label="Change" />
              <Dialog v-model:visible="visibleSalary" modal :closable="false" :style="{ width: '30rem' }" 
                :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
                <template #header>
                  <div class="flex align-items-center">
                    <i class="pi pi-euro" style="font-size: 1.5rem"></i>
                    <b class="text-2xl ml-2">Change Salary</b>
                  </div>
                </template>
                <!-- CONTENT DIALOG CHANGE TELEGRAM CHAT ID -->
                <div class="mt-4">
                  <!-- GROUP NAME & STRATING AMOUNT -->
                  <span class="col-12 p-float-label">
                    <InputText v-model="salary1" class="w-full" />
                    <label class="pl-2" for="chatId">1st Course</label>
                  </span>
                  <span class="col-12 p-float-label mt-4">
                    <InputText v-model="salary2" class="w-full" />
                    <label class="pl-2" for="chatId">2nd Course</label>
                  </span>
                </div>
                <!-- FOOTER DIALOG CHANGE TELEGRAM CHAT ID -->
                <template #footer>
                  <div class="flex justify-content-center w-full gap-3">
                    <Button label="Cancel" icon="pi pi-times" @click="visibleSalary = false" class="surface-300 border-400 text-black-alpha-90"/>
                    <Button label="Submit" icon="pi pi-upload" @click="saveSalary()" class="bg-green-500 border-green-600"/>
                  </div>
                </template>
              </Dialog>
            </div><!-- FI CHANGE TELEGRAM CHAT ID -->


            <!-- NEW GROUP -->
            <div class="ml-6 flex justify-content-between align-items-center mt-4">
              <div class="flex align-items-center">
                <i class="pi pi-plus-circle" style="font-size: 2rem"></i>
                <span class="ml-2">New group</span>
              </div>
              <Button @click="visible=true" label="Create" />
              <!-- DIALOG NEW GROUP -->
              <Dialog v-model:visible="visible" modal :closable="false" :style="{ width: '50rem' }" 
                :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
                <!-- HEADER DIALOG NEW GROUP -->
                <template #header>
                  <div class="flex align-items-center">
                    <i class="pi pi-plus-circle" style="font-size: 1.5rem"></i>
                    <b class="text-2xl ml-2">New Group</b>
                  </div>
                </template>
                <!-- CONTENT DIALOG NEW GROUP -->
                <div class="mt-4">
                  <!-- GROUP NAME & STRATING AMOUNT -->
                  <div class="card flex">
                    <span class="col-7 p-float-label">
                      <InputText v-model="groupName" class="w-full" :class="{'p-invalid': invalidGroupName}" />
                      <label class="pl-2" for="groupName">Group Name</label>
                    </span>
                    <span class="col-5 p-float-label">
                      <InputNumber v-model="startAmount" class="w-full" :minFractionDigits="0" :maxFractionDigits="2" mode="currency" currency="EUR" locale="de-DE" />
                      <label class="pl-2" for="startAmount">Starting Amount</label>
                    </span>
                  </div>
                  <div class="card flex">
                    <span class="col-7 p-float-label">
                      <InputText v-model="vlan" class="w-full" :class="{'p-invalid': invalidGroupVlan}" />
                      <label class="pl-2" for="groupName">Vlan</label>
                    </span>
                  </div>
                  <div class="card flex mt-2">
                    <span class="col-12 p-float-label">
                      <Textarea autoResize rows="5" cols="30" v-model="users" id="users" placeholder="marc, lluc..." class="w-full" />
                      <label class="pl-2 pt-2" for="users">Users</label>
                    </span>
                  </div>
                </div>
                <!-- FOOTER DIALOG NEW GROUP -->
                <template #footer>
                  <div class="flex justify-content-center w-full gap-3">
                    <Button label="Cancel" icon="pi pi-times" @click="visible = false" class="surface-300 border-400 text-black-alpha-90"/>
                    <Button label="Submit" icon="pi pi-upload" @click="createGroup()" class="bg-green-500 border-green-600"/>
                  </div>
                </template>
              </Dialog>
            </div><!-- FI NEW GROUP -->



            <!-- CHANGE TELEGRAM CHAT ID -->
            <div class="ml-6 flex justify-content-between align-items-center mt-4">
              <div class="flex align-items-center">
                <i class="pi pi-telegram" style="font-size: 2rem"></i>
                <span class="ml-2">Change Telegram Chat ID</span>
              </div>
              <Button @click="visibleChangeTelegram=true; getChatId();" label="Change" />
              <!-- DIALOG CHANGE TELEGRAM CHAT ID -->
              <Dialog v-model:visible="visibleChangeTelegram" modal :closable="false" :style="{ width: '30rem' }" 
                :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
                <!-- HEADER DIALOG CHANGE TELEGRAM CHAT ID -->
                <template #header>
                  <div class="flex align-items-center">
                    <i class="pi pi-telegram" style="font-size: 1.5rem"></i>
                    <b class="text-2xl ml-2">Change Telegram Chat ID</b>
                  </div>
                </template>
                <!-- CONTENT DIALOG CHANGE TELEGRAM CHAT ID -->
                <div class="mt-4">
                  <!-- GROUP NAME & STRATING AMOUNT -->
                  <span class="col-12 p-float-label">
                    <InputText v-model="chatId" class="w-full" />
                    <label class="pl-2" for="chatId">Chat ID</label>
                  </span>
                </div>
                <!-- FOOTER DIALOG CHANGE TELEGRAM CHAT ID -->
                <template #footer>
                  <div class="flex justify-content-center w-full gap-3">
                    <Button label="Cancel" icon="pi pi-times" @click="visibleChangeTelegram = false" class="surface-300 border-400 text-black-alpha-90"/>
                    <Button label="Submit" icon="pi pi-upload" @click="saveChatId()" class="bg-green-500 border-green-600"/>
                  </div>
                </template>
              </Dialog>
            </div><!-- FI CHANGE TELEGRAM CHAT ID -->


            <!-- CHANGE TELEGRAM ALERT CHAT ID -->
            <div class="ml-6 flex justify-content-between align-items-center mt-4">
              <div class="flex align-items-center">
                <i class="pi pi-telegram" style="font-size: 2rem"></i>
                <span class="ml-2">Change Telegram Alert Chat ID</span>
              </div>
              <Button @click="visibleChangeTelegramAlert=true; getAlertChatId();" label="Change" />
              <!-- DIALOG CHANGE TELEGRAM CHAT ID -->
              <Dialog v-model:visible="visibleChangeTelegramAlert" modal :closable="false" :style="{ width: '30rem' }" 
                :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
                <!-- HEADER DIALOG CHANGE TELEGRAM CHAT ID -->
                <template #header>
                  <div class="flex align-items-center">
                    <i class="pi pi-telegram" style="font-size: 1.5rem"></i>
                    <b class="text-2xl ml-2">Change Telegram Alert Chat ID</b>
                  </div>
                </template>
                <!-- CONTENT DIALOG CHANGE TELEGRAM CHAT ID -->
                <div class="mt-4">
                  <!-- GROUP NAME & STRATING AMOUNT -->
                  <span class="col-12 p-float-label">
                    <InputText v-model="alertChatId" class="w-full" />
                    <label class="pl-2" for="chatId">Alert Chat ID</label>
                  </span>
                </div>
                <!-- FOOTER DIALOG CHANGE TELEGRAM CHAT ID -->
                <template #footer>
                  <div class="flex justify-content-center w-full gap-3">
                    <Button label="Cancel" icon="pi pi-times" @click="visibleChangeTelegramAlert = false" class="surface-300 border-400 text-black-alpha-90"/>
                    <Button label="Submit" icon="pi pi-upload" @click="saveAlertChatId()" class="bg-green-500 border-green-600"/>
                  </div>
                </template>
              </Dialog>
            </div><!-- FI CHANGE TELEGRAM ALERT CHAT ID -->



          </div> <!-- FI GLOBAL SETTINGS -->













        
        </div><!-- FI DIV GENERAL DE CONFIG -->

        









      </template>
    </Card>

    <!-- TOAST -->
    <Toast/>
    <!-- CONFIRM DIALOG -->
    <ConfirmDialog></ConfirmDialog>
    <!-- LOADING PROGRESS SPINNER -->
    <Dialog v-model:visible="loading" header="Loading..." modal :closable="false">
      <ProgressSpinner />
    </Dialog>
  </div>
</template>
