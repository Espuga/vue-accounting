<script setup>
import { ref, inject, onMounted } from 'vue'
import axios from 'axios'
import HoursSelector from './hoursSelector.vue';

const group = inject('selectedGroup')

// Dialog
const projectDialog = ref(true);
const usersList = ref([])
const projectTitle = ref()
const projectDescription = ref()


const fundsChecked = ref(false)
const currentDate = new Date()
const formatDate = ref(currentDate.getFullYear()+"-"+(parseInt(currentDate.getMonth())+1)+"-"+currentDate.getDate())
const fundsDate = ref(formatDate)

const projectDialogApp = inject('projectDialog')
const loading = inject('loading')
const toast = inject('toast')

// CLOSE TRANSACTION DATA DIALOG
const closeprojectDialog = () => {
  projectDialogApp.update()
}


// SUBMIT TRANSACTION DATA
const submitTransaction = () => {
  // console.log(usersList.value)
  let hours = {}
  usersList.value.forEach((user) => {
    hours[user.id] = {"hours": user.hours, "minutes": user.minutes}
  })
  let date = new Date(fundsDate.value)
  let formatDate = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
  let obj = {
    title: projectTitle.value, 
    description: projectDescription.value,
    group_id: group.data.value.id,
    data: formatDate,
    users_hours: hours
  }
  // console.log(obj)
  axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/projects/newProject", obj)
    .then((res) => {
      if(res.data) {
        toast.toast('success', 'Saved!', 'The new project was saved.')
        closeprojectDialog()
      }else {
        toast.toast('error', 'Error!', 'Error saving the new project.')
      }
    })
}


// RESET TRANSACTION DATE (CURRENT DATE)
const changeChecked = () => {
  if(fundsChecked.value == false){
    formatDate.value = currentDate.getFullYear()+"-"+(parseInt(currentDate.getMonth())+1)+"-"+currentDate.getDate()
  }
}

onMounted(() => {
  // updateProjects.update()
  // console.log(updateProjects.data)
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/settings/getUsers", {params: {groupId: group.data.value.id}})
    .then((res) => {
      if(res.data.ok) {
        res.data.users.forEach((us) => {
          delete us.rights
          us.hours = 0
          us.minutes = 0
          console.log(us)
          usersList.value.push(us)
        })
      }else {
        toast.toast('error', 'Error!', 'Fill all gaps.')
      }
    })
})
</script>



<template>

<Dialog v-model:visible="projectDialog" modal :closable="false" :style="{ width: '50rem' }" 
:breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
  <!-- HEADER -->
  <template #header>
    <div class="flex align-items-center">
      <i class="pi pi-plus-circle" style="font-size: 1.5rem"></i>
      <b class="text-2xl ml-2">New Project</b>
    </div>
  </template>
  <!-- MAIN CONTENT -->

  <div class="mt-4">
    <div class="d-flex">
      <div class="col-12 w-full">
        <span class="col-12 p-float-label">
          <InputText v-model="projectTitle" class="w-full" />
          <label class="pl-2" for="title">Title</label>
        </span>
      </div>
      <div class="col-12 w-full">
        <span class="col-12 p-float-label">
          <Textarea v-model="projectDescription" autoResize rows="5" cols="30" class="w-full" />
          <label for="description" class="pl-2 pt-2">Description</label>
        </span>
      </div>
    </div>
    
    <div class="d-flex">
      <DataView :value="usersList" scrollable >
        <template #list="slotProps">
          <div class="grid grid-nogutter">
            <div v-for="(item, index) in slotProps.items" :key="index" class="col-12">
              <div class="flex flex-column xl:flex-row xl:align-items-center pl-4 pr-4 pt-2 pb-2 gap-4" :class="{ 'border-top-1 surface-border': index !== 0 }">
                <i class="pi pi-user" style="font-size: 2rem"></i>
                <div class="flex flex-column sm:flex-row justify-content-between align-items-center flex-1 gap-4">
                  <div class="">{{ item.name }}</div>
                  <div class="flex align-items-center sm:align-items-end gap-3 sm:gap-2">
                    
                    <HoursSelector :item="item"></HoursSelector>

                  </div>
                </div>
              </div>
            </div>
          </div>
        </template>
      </DataView>

      <div class="card flex ml-2 mr-5 mt-4 justify-content-right align-items-center">
        <label for="changeDate" class="flex align-items-center"><i class="pi pi-calendar" style="font-size: 1.5rem"></i>Change date</label>
        <InputSwitch v-model="fundsChecked" @change="changeChecked" class="ml-2" />
      </div>
      <div v-if="fundsChecked==true" class="card flex ml-2 mr-5 mt-2 justify-content-right">
        <Calendar v-model="fundsDate" dateFormat="yy-mm-dd" />
      </div >
    </div>

  </div>
  <!-- FOOTER -->
  <template #footer>
    <div class="flex justify-content-center w-full gap-3">
      <Button label="Cancel" icon="pi pi-times" @click="closeprojectDialog" class="surface-300 border-400 text-black-alpha-90"/>
      <Button label="Submit" icon="pi pi-upload" @click="submitTransaction" class="bg-green-600 border-green-700"/>
    </div>
  </template>
</Dialog>
</template>