<script setup>
// =============================
//          Import
import { onMounted, inject, ref } from 'vue';

import accountingCard from './../components/accountingCard.vue'
import vmachinesCard from './../components/vmachinesCard.vue'
import usersCard from './../components/usersCard.vue'
import userCard from './../components/userCard.vue'
import IndexedDBService from '../services/IndexedDBService';

// =============================
//          Const
const toast = inject('toast')
const teacher = ref(false)
const groups = inject('groups')
const groups2 = groups.data

// =============================
//          Functions

const getRights = async () => {
  let rights = await IndexedDBService.obtenerDatos(0)
  if(rights != undefined){
    if(rights.rights.includes(2, 0)) {
      teacher.value = true
      // getInitTeacher()
    } else {
      teacher.value = false
      // getDataTable()
    }
  } else {
    teacher.value = false
    // getDataTable()
  }
  
}

onMounted(() => {
  document.title = "Home"
  getRights()
})


</script>


<template>
  <!-- CENTRAL SQUARE WITH 2 CARDS -->

  <div v-if="teacher" class="flex justify-content-center align-items-start  border-round-xl">
    <div v-for="group in groups2" class="col-4 flex jusitfy-content-center align-items-center">
      <div class="w-full border-round-xl shadow-5 pt-0 color-0">
        <div class="w-full flex justify-content-center align-items-center">
          <h1 class="text-black-alpha-80 text-5xl m-2">{{ group.nom }}</h1>
        </div>
          <accountingCard :group="group" class="col-11 shadow-5 m-auto"></accountingCard>
          <br>
          <vmachinesCard :group="group" class="col-11 shadow-5 m-auto"></vmachinesCard>
          <br>
          <usersCard :group="group" class="col-11 shadow-5 m-auto"></usersCard>
          <br>
      </div>
    </div>

  </div>

  <div v-else class=" h-screen2 flex justify-content-center align-items-center">
    
    <div v-if="groups2.length>0" class="col-8 flex jusitfy-content-center align-items-center p-3 color-0 border-round-xl shadow-5">
      <div class="w-full pt-0">
        <div class="w-full flex justify-content-center align-items-center">
          <h1 class=" text-5xl m-2">{{ groups2[0].nom }}</h1>
        </div>
        <div class="flex gap-3 justify-content-center p-4 pb-1">
          <accountingCard :group="groups2[0]" class="col-6 shadow-5"></accountingCard>
          <vmachinesCard :group="groups2[0]" class="col-6 shadow-5"></vmachinesCard>
        </div>
        <div class="flex gap-3 justify-content-center align-items-start p-4 pt-0">
          <usersCard :group="groups2[0]" class="col-6 shadow-5"></usersCard>
          <userCard class="col-6 shadow-5"></userCard>
        </div>
        <br>
      </div>
    </div>
  </div>
</template>
