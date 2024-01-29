<script setup>

</script>

<template>
  <div class="small-box bg-blue">
    <div class="inner">
      <h3>18</h3>
      <p>Proxmox VMachines</p>
    </div>
    <div class="icon">
      <i class="pi pi-desktop"></i>
    </div>
    <router-link v-slot="{ href, navigate }" to="/vmachines" custom>
      <a :href="href" @click="navigate" class="small-box-footer">
        VMachines <i class="fas fa-arrow-circle-right"></i>
      </a>
    </router-link>
  </div>
</template>

<style scoped>
@import 'admin-lte/dist/css/adminlte.css';
@import 'admin-lte/plugins/fontawesome-free/css/all.min.css';
</style>