<script setup>
// =============================
//          Import
import { onMounted } from 'vue';

import accountingCard from './../components/accountingCard.vue'
import vmachinesCard from './../components/vmachinesCard.vue'

// =============================
//          Const


// =============================
//          Functions

onMounted(() => {
  document.title = "Home"
})


</script>


<template>
  <!-- CENTRAL SQUARE WITH 2 CARDS -->
  <div class=" h-screen2 flex justify-content-center align-items-center">
    <div class="flex col-8 p-8 gap-4 bg-white border-round-xl justify-content-center align-items-center shadow-5">
      <accountingCard class="col-6 shadow-5"></accountingCard>
      <vmachinesCard class="col-6 shadow-5"></vmachinesCard>
    </div>
  </div>
</template>
