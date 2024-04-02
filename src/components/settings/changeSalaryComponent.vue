<script setup>
import { ref, inject } from 'vue'
import axios from 'axios'

const toast = inject('toast')
const loading = inject('toast')

// Salary
const visibleSalary = ref(false)
const salary1 = ref()
const salary2 = ref()

const getSalary = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/settings/getSalary")
    .then((res) => {
      if(res.data.ok) {
        salary1.value = res.data.firstCourse
        salary2.value = res.data.secondCourse
      }else {
        toast.toast('error', 'Error!', 'Error getting the prices.')
      }
    })
}

const saveSalary = () => {
  axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/settings/saveSalary", {salary1: salary1.value, salary2: salary2.value})
    .then((res) => {
      if(res.data) {
        toast.toast('success', 'Saved!', 'The prices were saved successfully.')
        visibleSalary.value = false
      }else {
        toast.toast('error', 'Error!', 'Error saving the prices.')
      }
    })
}

</script>

<template>
  <div class="ml-6 flex justify-content-between align-items-center mt-4">
    <div class="flex align-items-center">
      <i class="pi pi-euro" style="font-size: 2rem"></i>
      <span class="ml-2">Change Salary</span>
    </div>
    <Button @click="visibleSalary=true; getSalary();" label="Change" class="color-light-blue-2 text-blue-500 border-blue-600 w-2"  />
    <Dialog v-model:visible="visibleSalary" modal @keyup.esc="visibleSalary = false" :closable="false" :style="{ width: '30rem' }" 
      :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
      <template #header>
        <div class="flex align-items-center">
          <i class="pi pi-euro" style="font-size: 1.5rem"></i>
          <b class="text-2xl ml-2">Change Salary</b>
        </div>
      </template>
      <!-- CONTENT DIALOG CHANGE TELEGRAM CHAT ID -->
      <div class="p-4 pt-5 color-1 shadow-3 border-round-xl flex flex-column">
        <!-- GROUP NAME & STRATING AMOUNT -->
        <span class="col-12 flex flex-column justify-content-center">
          <label class="ml-2" for="chatId">1st Course</label>
          <IconField iconPosition="left">
            <i class="pi pi-euro"> </i>
            <InputText v-model="salary1" class="w-full mt-1" @keyup.enter="saveSalary()" autofocus/>
          </IconField>
        </span>
        <span class="col-12">
          <label class="ml-2" for="chatId">2nd Course</label>
          <IconField iconPosition="left">
            <i class="pi pi-euro"> </i>
            <InputText v-model="salary2" class="w-full mt-1" @keyup.enter="saveSalary()"/>
          </IconField>
        </span>
      </div>
      <!-- FOOTER DIALOG CHANGE TELEGRAM CHAT ID -->
      <template #footer>
        <div class="flex justify-content-center w-full gap-3">
          <Button label="Cancel" icon="pi pi-times" @click="visibleSalary = false" class="opacity-80 surface-200 border-400 color-1 text-black-alpha-90"/>
          <Button label="Submit" icon="pi pi-save" @click="saveSalary()" class="color-light-green text-green-500 border-green-600"/>
        </div>
      </template>
    </Dialog>
  </div>
</template>