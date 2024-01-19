<script setup>
// =============================
//          Import
import axios from "axios";
import { ref, onMounted, inject, watch } from "vue";
import { useToast } from "primevue/usetoast";
import { useConfirm } from "primevue/useconfirm";

// =============================
//          Const

// GLOBAL
const toast = useToast();
const confirm = useConfirm();
const charging = ref(false)

// USER 
const user = inject('user')
const groups = ref(inject('groups'));
const group = ref(null)
const selectedGroup = inject('selectedGroup')
watch(() => selectedGroup.data.value, changeSelectedGroup);
const admin = inject('isAdmin')
const isAdmin = ref(false)
watch(() => admin.data.value, changeAdmin);

// NEW GROUP DIALOG
const visible = ref(false)
const groupName = ref("")
const startAmount = ref(null)

// CHANGE MEMBERS DIALOG
const changeVisible = ref(false)
const users = ref("")
const usersList = ref([])


// =============================
//          Functions


// CHANGE ADMIN VALUE
const changeAdmin = () => {
  isAdmin.value = admin.data.value
}

// CHANGE SELECTED GROUP
const changeSelectedGroup = () => {
  group.value = selectedGroup.data.value
}

// CHANGE App.vue GROUP VALUE 
const changeGroup = async () => {
  selectedGroup.updateGroup(group.value)
  selectedGroup.updateChart(group.value.id)
  await admin.updateAdmin(group.value.id)
  // console.log(admin.data.value)
}

// CREATE NEW GROUP
const createGroup = () => {
  let newGroupData = { 
    token: window.$cookies.get("auth"), 
    name: groupName.value, 
    amount: startAmount.value,  
    users: users.value
  }
  charging.value = true;
  axios.post(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/createGroup', newGroupData )
    .then((res) => {
      if(res.data){
        // Refrescar groups
        toast.add({ severity: 'success', summary: 'Created Correclty', detail: 'Group Created Correctly', life: 4000 });
      }else{
        toast.add({ severity: 'error', summary: 'Error', detail: 'Error creating the group', life: 4000 });
      }
      charging.value = false;
    })
}

// CHANGE MEMBERS
const changeMembers = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/changeMembers', { params: { token: window.$cookies.get("auth"), groupId: group.value.id, users: users.value } })
    .then((res) => {
      if(res.data){
        users.value = ""
        openChangeMembers()
        toast.add({ severity: 'success', summary: 'Added Users', detail: 'Correclty added users', life: 4000 });
      }else{
        toast.add({ severity: 'error', summary: 'Error', detail: 'Error adding users', life: 4000 });
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
      charging.value = true;
      axios.delete(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/quitUser', {params: {groupId: group.value.id, userId: id}})
        .then((res) => {
          if(res.data){
            openChangeMembers()
            toast.add({ severity: 'success', summary: 'Confirmed', detail: 'User has been quited', life: 3000 });
          }else {
            toast.add({ severity: 'error', summary: 'Error', detail: 'An error occurred while quitting the user. Try it again.', life: 3000 });
          }
          charging.value = false;
        })
    },
    reject: () => {
      toast.add({ severity: 'warn', summary: 'Cancelled', detail: 'User hasn\'t been quited', life: 3000 });
    }
  });
}

// OPEN CHANGE MEMBERS DIALOG
const openChangeMembers = () => {
  if(group.value == null){
    toast.add({ severity: 'warn', summary: 'No group selected', detail: 'Please, select a group to manage it.', life: 3000 });
  }else{ 
    changeVisible.value = true
    charging.value = true;
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/getUsers', { params: { groupId: group.value.id } } )
      .then((res) => {
        if(res.data.ok){
          // posar els users amb una v-for o posar els usuaris en una llista, depen del component (slotProps.item)
          // console.log(res.data.users)
          usersList.value = res.data.users
        }else{
          toast.add({ severity: 'error', summary: 'Error', detail: 'An error occurred while getting users. Try it again.', life: 3000 });
        }
        charging.value = false;
      })
  }
}

// DLETE GROUP CONFIRMATION
const openDeleteGroup = () => {
  if(group.value == null){
    toast.add({ severity: 'warn', summary: 'No group selected', detail: 'Please, select a group to manage it.', life: 3000 });
  }else {
    confirm.require({
      message: 'Are you sure you want to proceed?',
      header: 'Confirmation',
      icon: 'pi pi-exclamation-triangle',
      accept: () => {
      charging.value = true;
        axios.delete(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/deleteGroup', {params: {groupId: group.value.id}})
          .then((res) => {
            if(res.data){
              // Refrescar groups
              toast.add({ severity: 'success', summary: 'Confirmed', detail: 'Group has been deleted', life: 3000 });
            }else {
              toast.add({ severity: 'error', summary: 'Error', detail: 'An error occurred while deleting the group. Try it again.', life: 3000 });
            }
            charging.value = false;
          })
      },
      reject: () => {
        toast.add({ severity: 'warn', summary: 'Cancelled', detail: 'Group hasn\'t been deleted.', life: 3000 });
      }
    });
  }
}

// ON MOUNTED
onMounted(() => {
  document.title = "Accounting - Settings"
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
          <div class="flex justify-content-between align-items-center">
            <div class="flex align-items-center">
              <i class="pi pi-arrow-right-arrow-left" style="font-size: 1.3rem"></i>
              <span class="ml-2">Change group</span>
            </div>
            <Dropdown @change="changeGroup()" v-model="group" :options="groups" optionLabel="name" placeholder="Select a Group" class="w-full md:w-14rem" />
          </div>

          <!-- NEW GROUP -->
          <div class="flex justify-content-between align-items-center mt-4">
            <div class="flex align-items-center">
              <i class="pi pi-plus-circle" style="font-size: 1.3rem"></i>
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
                    <InputText v-model="groupName" class="w-full" />
                    <label class="pl-2" for="groupName">Group Name</label>
                  </span>
                  <span class="col-5 p-float-label">
                    <InputNumber v-model="startAmount" class="w-full" :minFractionDigits="0" :maxFractionDigits="2" mode="currency" currency="EUR" locale="de-DE" />
                    <label class="pl-2" for="startAmount">Starting Amount</label>
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
                <div class="flex justify-content-center">
                  <Button label="Cancel" icon="pi pi-times" @click="visible = false" class="surface-300 border-400 text-black-alpha-90"/>
                  <Button label="Submit" icon="pi pi-upload" @click="createGroup()" class="bg-green-500 border-green-600"/>
                </div>
              </template>
            </Dialog>
          </div>
          <Divider/>
          <!-- GROUP SETTINGS -->
          <div class="flex align-items-center">
              <h3>Group Settings</h3>
          </div>
          <div class="ml-6">
            <!-- CHANGE MEMBERS -->
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
                            <div class="">{{ item.username }}</div>
                            <div class="flex sm:flex-column align-items-center sm:align-items-end gap-3 sm:gap-2">
                              <Button v-if="isAdmin" icon="pi pi-times p-0" @click="confirmQuitUser(item.id)" rounded :disabled="item.name===user"></Button>
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
                <div v-if="isAdmin" class="card flex align-items-center mt-2">
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

            </div> <!-- fi change members -->
          </div>


          <div v-if="isAdmin" class="ml-6 mt-4">
            <!-- DELETE GROUP -->
            <div class="flex justify-content-between align-items-center">
              <div class="flex align-items-center">
                <i class="pi pi-trash" style="font-size: 2rem"></i>
                <span class="ml-2">Delete Group</span>
              </div>
              <Button @click="openDeleteGroup()" label="Delete" />

            </div> <!-- FI DELETE GROUP -->
          </div>
        </div>
      </template>
    </Card>

    <!-- TOAST -->
    <Toast/>
    <!-- CONFIRM DIALOG -->
    <ConfirmDialog></ConfirmDialog>
    <!-- LOADING PROGRESS SPINNER -->
    <Dialog v-model:visible="charging" header="Loading..." modal :closable="false">
      <ProgressSpinner />
    </Dialog>
  </div>
</template>
