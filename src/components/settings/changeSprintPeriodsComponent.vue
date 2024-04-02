<script setup>
import { ref, inject } from 'vue'
import axios from 'axios'

const loading = inject('loading')
const toast = inject('toast')

// CHANGE SPRINT PERIODS
const visibleSprintPeriods = ref(false)
const sprints = ref(null)

const openChangeSprintPeriods = () => {
  visibleSprintPeriods.value = true 
  loading.load(true)
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/settings/getSprints')
    .then((res) => {
      loading.load(false)
      if(res.data.ok) {
        sprints.value = res.data.sprints
      }
    })
}

const saveSprintPeriods = () => {
  loading.load(true)
  var toSubmit = []
  sprints.value.forEach((s) => {
    let aux = {}
    aux.name = s.name
    let dat = new Date(s.date)
    aux.date = dat.getFullYear()+"-"+((dat.getMonth()+1).toString().length==1 ? "0" : "")+(dat.getMonth()+1)+"-"+(dat.getDate().toString().length==1 ? "0" : "")+dat.getDate()
    let end = new Date(s.end)
    aux.end = end.getFullYear()+"-"+((end.getMonth()+1).toString().length==1 ? "0" : "")+(end.getMonth()+1)+"-"+(end.getDate().toString().length==1 ? "0" : "")+end.getDate()
    toSubmit.push(aux)
  })
  axios.post(import.meta.env.VITE_APP_BACKEND_IP + '/settings/updateSprints', toSubmit) 
    .then((res) => {
      loading.load(false)
      if(res.data){
        toast.toast('success', 'Saved!', 'Sprints has been saved.')
        openChangeSprintPeriods()
      }else {
        toast.toast('error', 'Error!', 'Sprints hasn\'t been saved.')
      }
    })
}

</script>

<template>
  <div class="ml-6">
    <div class="flex justify-content-between align-items-center">
      <div class="flex align-items-center">
        <i class="pi pi-calendar" style="font-size: 2rem"></i>
        <span class="ml-2">Change Sprint Periods</span>
      </div>
      <Button @click="openChangeSprintPeriods()" label="Change" class="color-light-blue-2 text-blue-500 border-blue-600 w-2" />


      <Dialog v-model:visible="visibleSprintPeriods" modal @keyup.esc="visibleSprintPeriods = false" :closable="false" :style="{ width: '40rem', maxHeight: '75vh' }" 
      :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
      <!-- HEADER DIALOG SPRINT PERIODS -->
      <template #header>
        <div class="flex align-items-center">
          <i class="pi pi-users" style="font-size: 1.5rem"></i>
          <b class="text-2xl ml-2">Change Sprint Periods</b>
        </div>
      </template>
      <!-- CONTENT DIALOG SPRINT PERIODS -->
      <div class="p-4 color-1 shadow-3 border-round-xl">
        <!-- LIST SPRINTS -->
        <DataView :value="sprints" scrollable :pt="{
          content: { class: 'border-round-xl shadow-2' }
        }">
          <template #list="slotProps">
            <div class="grid grid-nogutter">
              <div v-for="(item, index) in slotProps.items" :key="index" class="col-12">
                <div class="flex flex-column xl:flex-row xl:align-items-center pl-4 pr-4 pt-2 pb-2 gap-4" :class="{ 'border-top-1 surface-border': index !== 0 }">
                  <i class="pi pi-stopwatch" style="font-size: 2rem"></i>
                  <div class="flex flex-column sm:flex-row justify-content-between align-items-center flex-1 gap-4">
                    <div class="col-3">{{ item.name }}</div>
                    <div class="col-9 flex align-items-center sm:align-items-end gap-3 sm:gap-2">
                      <Calendar v-model="item.date" dateFormat="yy-mm-dd" :utc="true" class="col-6" />
                      <Calendar v-model="item.end" dateFormat="yy-mm-dd" :utc="true" class="col-6" />
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
        <div class="flex justify-content-center w-full gap-3 mt-2">
          <Button label="Cancel" icon="pi pi-times" @click="visibleSprintPeriods = false" autofocus class="opacity-80 surface-200 border-400 color-1 text-black-alpha-90"/>
          <Button label="Save" icon="pi pi-save" @click="saveSprintPeriods()" class="color-light-green text-green-500 border-green-600"/>
        </div>
      </template>
    </Dialog>


    </div> 
  </div>
</template>