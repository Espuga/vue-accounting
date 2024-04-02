<script setup>
import { ref, inject, onMounted } from 'vue'
import axios from 'axios'

const group = inject('selectedGroup')

// Dialog
const projectDialog = ref(true);

const recordDialogApp = inject('recordDialog')
const loading = inject('loading')
const toast = inject('toast')

const project = ref(null);
const projects = ref();
const invalidProject = ref(false)


const play = ref(false)
const id = ref(null)

// CLOSE DIALOG
const closeprojectDialog = () => {
  recordDialogApp.update()
}

const changePlay = () => {
  if(project.value==null) {
    invalidProject.value = true
  } else {
    invalidProject.value = false
    if (play.value==false) {
      axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/records/start", {token: window.$cookies.get("auth"), project_id: project.value.id})
        .then((res) => {
          if(res.data.ok) {
            id.value = res.data.id
            play.value = !play.value
          } else {
            toast.toast('error', 'Error!', 'Error starting recording.')
          }
        })
    } else {
      axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/records/stop", {params: {id: id.value}})
        .then((res) => {
          if(res.data) {
            toast.toast('success', 'Saved!', 'The time was saved successfully.')
            play.value = !play.value
          }else {
            toast.toast('error', 'Error!', 'Error stopping recording.')
          }
        })
    }
  }
}

onMounted(() => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/records/getInit", {params: {id: group.data.value.id, token: window.$cookies.get('auth')}})
    .then((res) => {
      if(res.data.ok) {
        // console.log(res.data.projects)
        projects.value = res.data.projects
        if(res.data.id!=null) {
          id.value = res.data.id
          projects.value.forEach((proj) => {
            if(proj.id == res.data.project_id) {
              project.value = proj
              play.value = true
              return;
            }
          })
        }
        
      } else {
        toast.toast('error', 'Error!', 'Error getting the Projects')
      }
    })
})
</script>



<template>

<Dialog v-model:visible="projectDialog" modal @keyup.esc="closeprojectDialog()" :closable="false" :style="{ width: '50rem' }" 
:breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
  <!-- HEADER -->
  <template #header>
    <div class="flex align-items-center">
      <i class="pi pi-play" style="font-size: 2.5rem"></i>
      <b class="text-2xl ml-2">Record Hours</b>
    </div>
  </template>
  <!-- MAIN CONTENT -->

  <div class="flex flex-column justify-content-center align-items-center mt-2 color-1 border-round-2xl shadow-3 pt-3">
    <div class="flex flex-column">
      <label class="mb-2 ml-2 text-lg">Project</label>
      <Dropdown v-model="project" :options="projects" optionLabel="title" placeholder="Select a Project" class="w-full md:w-30rem" :class="{'p-invalid': invalidProject}" />
    </div>
    <div class="w-full flex justify-content-center align-items-center py-3 mt-3">
      <div v-if="!play" class="cursor-pointer p-1 border-circle flex justify-content-center align-items-center p-2" v-tooltip.bottom="'Play'">
        <i @click="changePlay" class="pi pi-play relative ml-2 scale-1" style="font-size: 3.5rem"></i>
      </div>
      <div v-else class="cursor-pointer p-1 border-circle flex justify-content-center align-items-center p-2" v-tooltip.bottom="'Stop'">
        <i @click="changePlay" class="pi pi-stop relative ml-2 scale-1" style="font-size: 3.5rem"></i>
      </div>
    </div>
  </div>

  <template #footer>
    <div class="w-full flex justify-content-center align-items-center">
      <Button label="Exit" icon="pi pi-sign-out" @click="closeprojectDialog" autofocus class="opacity-80 surface-200 border-400 text-black-alpha-90"/>
    </div>
  </template>
</Dialog>
</template>