<script setup>
import { ref, onMounted, inject } from 'vue'
import axios from 'axios'

const group = inject('selectedGroup')
const toast = inject('toast')
const teacher = inject('teacher')

const name = ref()
const numProjects = ref()
const sumHours = ref()
const sprintSalary = ref()
const money = ref()


const getUserInfo = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/home/getUserInfo', { params: { token: window.$cookies.get("auth"), groupId: group.data.value.id } } )
    .then((res) => {
      if(res.data.ok){
        name.value = res.data.name
        numProjects.value = res.data.numProjects
        sumHours.value = res.data.sumHours
        sprintSalary.value = res.data.sprintSalary
        money.value = res.data.money
      }else{
        toast.toast('error', 'Error!', 'An error occurred while getting your information. Try it again.')
      }
    })
}


onMounted(() => {
  if(!teacher) {
    getUserInfo()
  }
})


</script>

<template>
  <div class="small-box color-light-orange border-orange-1">
    <div class="inner">
      <h3 class="">{{ name }}</h3>
    </div>
    <div class="icon text-black-alpha-80">
      <i class="pi pi-user"></i>
    </div>

    <div class="ml-2 mb-3 ">
      <p class="inline-block text-lg my-0 font-bold">Projects: </p><p class="inline-block ml-1 my-0">{{ numProjects }}</p>
      <Divider class="my-1 w-4"/>
      <p class="inline-block text-lg m-0 font-bold">Hours: </p><p class="inline-block ml-1 my-0">{{ sumHours }}</p>
      <Divider class="my-1 w-4"/>
      <p class="inline-block text-lg m-0 font-bold">Sprint salary: </p><p class="inline-block ml-1 my-0">{{ sprintSalary }} €</p>
      <Divider class="my-1 w-5"/>
      <p class="inline-block text-lg m-0 font-bold">Money: </p><p class="inline-block ml-1 my-0">{{ money }} €</p>
    </div>

    <router-link v-slot="{ href, navigate }" to="/profile" custom>
      <a :href="href" @click="navigate" class="small-box-footer text-black-alpha-70">
        <p class="inline-block m-0">Profile</p> <i class="fas fa-arrow-circle-right"></i>
      </a>
    </router-link>

  </div>
</template>

<style scoped>
@import 'admin-lte/dist/css/adminlte.css';
@import 'admin-lte/plugins/fontawesome-free/css/all.min.css';
</style>