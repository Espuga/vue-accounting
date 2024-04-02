<script setup>
// ===========================
//           import
import { ref, inject, watch, onMounted } from 'vue'
import axios from 'axios'
import { useConfirm } from "primevue/useconfirm";


// ===========================
//           const
// Library 
const confirm = useConfirm();

// General
const toast = inject('toast')
const group = ref(null)
const selectedGroup = inject('selectedGroup')
const changeSelectedGroup = () => {
  group.value = selectedGroup.data.value
} 
watch(() => selectedGroup.data.value, changeSelectedGroup);
const admin = inject('isAdmin')
const teacher = inject('teacher')

// CHANGE MEMBERS DIALOG
const changeVisible = ref(false)
const users = ref("")
const usersList = ref([])
const userRightsVisible = ref(false)
const nameUserRights = ref()
const rights = ref([])
const selectedRights = ref([])
const userIdRights = ref()


// ===========================
//         functions

// CHANGE MEMBERS
const changeMembers = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/settings/changeMembers', { params: { token: window.$cookies.get("auth"), groupId: group.value.id, users: users.value } })
    .then((res) => {
      if(res.data){
        users.value = ""
        openChangeMembers()
        toast.toast('success', 'Added Users!', 'Correclty added users.')
      }else{
        toast.toast('error', 'Error!', 'Error adding users.')
      }
    })
}

// CONFIRM QUIT USERS
const confirmQuitUser = (id) => {
  confirm.require({
    group: 'headless',
    message: 'Are you sure you want to proceed?',
    header: 'Confirmation',
    icon: 'pi pi-exclamation-triangle',
    accept: () => {
      axios.delete(import.meta.env.VITE_APP_BACKEND_IP + '/settings/quitUser', {params: {groupId: group.value.id, userId: id}})
        .then((res) => {
          if(res.data){
            openChangeMembers()
            toast.toast('success', 'Confirmed!', 'User has been quited.')
          }else {
            toast.toast('success', 'Error!', 'An error occurred while quitting the user. Try it again.')
          }
        })
    },
    reject: () => {
      toast.toast('warn', 'Cancelled!', 'User hasn\'t been quited.')
    }
  });
}

// OPEN CHANGE MEMBERS DIALOG
const openChangeMembers = () => {
  if(group.value == null){
    toast.toast('warn', 'No group selected!', 'Please, select a group to manage it.')
  }else{ 
    changeVisible.value = true
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/settings/getUsers', { params: { groupId: group.value.id } } )
      .then((res) => {
        if(res.data.ok){
          usersList.value = res.data.users
        }else{
          toast.toast('error', 'Error!', 'An error occurred while getting users. Try it again.')
        }
      })
  }
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
            return;
          }
        })
      }else {
        toast.toast('error', 'Error!', 'Error getting the rights.')
      }
    })
}

const saveUserRights = () => {
  let object = {user_id: userIdRights.value, group_id: group.value.id, rights_id: selectedRights.value}
  axios.post(import.meta.env.VITE_APP_BACKEND_IP + "/settings/saveRights", object)
    .then((res) => {
      if(res.data){
        userRightsVisible.value = false
        toast.toast('success', 'Saved!', 'The rights have been saved.')
      }else {
        toast.toast('error', 'Error!', 'Error saving the rights.')
      }
    })
}

onMounted(() => {
  group.value = selectedGroup.data.value
})

</script>

<template>
  <div class="ml-6">
    <div class="flex justify-content-between align-items-center">
      <div class="flex align-items-center">
        <i class="pi pi-users" style="font-size: 2rem"></i>
        <span class="ml-2">Change members</span>
      </div>
      <Button @click="openChangeMembers()" label="Change" class="color-light-blue-2 text-blue-500 border-blue-600  w-2" :pt="{
        icon: {class: 'pi pi-cog'}
      }"/>

      <Dialog v-model:visible="changeVisible" modal @keyup.esc="changeVisible = false" :closable="false" :style="{ width: '35rem', maxHeight: '70vh' }" 
      :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
      <!-- HEADER DIALOG NEW GROUP -->
      <template #header>
        <div class="flex align-items-center">
          <i class="pi pi-users" style="font-size: 1.5rem"></i>
          <b class="text-2xl ml-2">Change Members</b>
        </div>
      </template>
      <!-- CONTENT DIALOG NEW GROUP -->
      <div class="p-4 color-1 shadow-3 border-round-xl" >
        <!-- LIST MEMBERS -->
        <DataView :value="usersList" scrollable :pt="{
          content: { class: 'border-round-xl shadow-2' }
        }">
          <template #list="slotProps">
            <div class="grid grid-nogutter">
              <div v-for="(item, index) in slotProps.items" :key="index" class="col-12">
                <div class="flex flex-column xl:flex-row xl:align-items-center pl-4 pr-4 pt-2 pb-2 gap-4" :class="{ 'border-top-1 surface-border': index !== 0 }">
                  <img v-if="item.img != ''" class="border-circle mr-2" style="width: 2rem" :src="item.img" />
                  <i v-else class="pi pi-user" style="font-size: 2rem"></i>
                  <div class="flex flex-column sm:flex-row justify-content-between align-items-center flex-1 gap-4">
                    <div class="">{{ item.name }}</div>
                    <div class="flex align-items-center sm:align-items-end gap-3 sm:gap-2">
                      <Button v-if="admin || teacher" icon="pi pi-book p-0" @click="openChangeRights(item.id, item.name)" rounded label="Rights"
                        class="color-1-s text-black-alpha-70 border-black-1 scale-1" ></Button>
                      <Button v-if="admin || teacher" icon="pi pi-times p-0" @click="confirmQuitUser(item.id)" rounded :disabled="item.id===group.admin_id"
                        class="color-1-s text-black-alpha-70 border-black-1 scale-1" ></Button>
                      
                      

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
        <div v-if="admin || teacher" class="card flex w-full px-2 border-round-sm shadow-3 mt-2 align-items-center mt-2 color-1">
          <span class="col-6 p-float-label">
            <InputText v-model="users" class="w-full" placeholder="marc, lluc..."  @keyup.enter="changeMembers()"/>
            <label class="pl-2" for="users">Username</label>
          </span>
          <div class="col-6 flex justify-content-center align-items-center gap-2">
            <Button label="Submit" icon="pi pi-save" @click="changeMembers()" class="color-light-green text-green-500 border-green-600"/>
            <Button label="Cancel" icon="pi pi-times" autofocus @click="changeVisible = false" class="opacity-80 surface-200 border-400 color-1 text-black-alpha-90"/>
          </div>
        </div>
        <div v-else class="flex justify-content-center">
          <Button label="Cancel" icon="pi pi-times" autofocus @click="changeVisible = false" class="opacity-80 surface-200 border-400 color-1 text-black-alpha-90"/>
        </div>
      </template>
    </Dialog>
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
        <div class="flex flex-column gap-3 card shadow-3 color-1 p-4 border-round">
          <div v-for="right of rights" :key="right.id" class="flex align-items-center">
            <Checkbox v-model="selectedRights" :inputId="right.id" name="right" :value="right.id" />
            <label :for="right.name" class="ml-2">{{ right.name }}</label>
          </div>
        </div>
      </div>

      <template #footer>
        <!-- ADD MEMBER -->
        <div class="flex justify-content-center w-full gap-3">
          <Button label="Cancel" icon="pi pi-times" @click="userRightsVisible = false; rights = []" class="opacity-80 surface-200 border-400 text-black-alpha-90"/>
          <Button label="Save" icon="pi pi-save" @click="saveUserRights" class="color-light-green text-green-500 border-green-600"/>
        </div>
      </template>
    </Dialog>
    <!-- END USER RIGHTS DIALOG -->
    </div> 
  </div>
</template>