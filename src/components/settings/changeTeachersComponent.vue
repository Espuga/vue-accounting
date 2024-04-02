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
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/settings/changeTeachers', 
    { params: { users: users.value } })
    .then((res) => {
      if(res.data){
        users.value = ""
        openChangeMembers()
        toast.toast('success', 'Added Users!', 'Correclty added teachers.')
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
      axios.delete(import.meta.env.VITE_APP_BACKEND_IP + '/settings/quitTeacher', {params: {userId: id}})
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
      toast.toast('warn', 'Cancelled!', 'Teacher hasn\'t been quited.')
    }
  });
}

// OPEN CHANGE MEMBERS DIALOG
const openChangeMembers = () => {
  changeVisible.value = true
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/settings/getTeachers')
    .then((res) => {
      if(res.data.ok){
        usersList.value = res.data.teachers
      }else{
        toast.toast('error', 'Error!', 'An error occurred while getting users. Try it again.')
      }
    })
}

onMounted(() => {
  group.value = selectedGroup.data.value
})

</script>

<template>
  <div class="ml-6 mt-4">
    <div class="flex justify-content-between align-items-center">
      <div class="flex align-items-center">
        <i class="pi pi-user-edit" style="font-size: 2rem"></i>
        <span class="ml-2">Change Teachers</span>
      </div>
      <Button @click="openChangeMembers()" label="Change" class="color-light-blue-2 text-blue-500 border-blue-600  w-2" :pt="{
        icon: {class: 'pi pi-cog'}
      }"/>

      <Dialog v-model:visible="changeVisible" modal @keyup.esc="changeVisible = false" :closable="false" :style="{ width: '35rem', maxHeight: '70vh' }" 
      :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
      <!-- HEADER DIALOG NEW GROUP -->
      <template #header>
        <div class="flex align-items-center">
          <i class="pi pi-user-edit" style="font-size: 1.5rem"></i>
          <b class="text-2xl ml-2">Change Teachers</b>
        </div>
      </template>
      <!-- CONTENT DIALOG NEW GROUP -->
      <div class="p-4 color-1 shadow-3 border-round-xl">
        <!-- LIST MEMBERS -->
        <DataView :value="usersList" scrollable :pt="{
          content: { class: 'border-round-xl shadow-2' }
        }">
          <template #list="slotProps">
            <div class="grid grid-nogutter">
              <div v-for="(item, index) in slotProps.items" :key="index" class="col-12">
                <div class="flex flex-column xl:flex-row xl:align-items-center pl-4 pr-4 pt-2 pb-2" :class="{ 'border-top-1 surface-border': index !== 0 }">
                  <img v-if="item.img != ''" class="border-circle mr-2" style="width: 2rem" :src="item.img" />
                  <i v-else class="pi pi-user mr-2" style="font-size: 2rem"></i>
                  <div class="flex flex-column sm:flex-row justify-content-between align-items-center flex-1 gap-4">
                    <div class="">{{ item.name }}</div>
                    <div class="flex align-items-center sm:align-items-end gap-3 sm:gap-2">
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
        <div class="card flex w-full px-2 border-round-sm shadow-3 mt-2 align-items-center mt-2 color-0">
          <span class="col-6 p-float-label">
            <InputText v-model="users" class="w-full" @keyup.enter="changeMembers()" placeholder="marc, lluc..." />
            <label class="pl-2" for="users">Username</label>
          </span>
          <div class="col-6 flex justify-content-center align-items-center gap-2">
            <Button label="Save" icon="pi pi-save" @click="changeMembers()" autofocus class="color-light-green text-green-500 border-green-600"/>
            <Button label="Cancel" icon="pi pi-times" @click="changeVisible = false" class="opacity-80 surface-200 border-400 color-1 text-black-alpha-90"/>
          </div>
        </div>
      </template>
    </Dialog>
    </div> 
  </div>
</template>