<script setup>
import { ref, onMounted, defineProps } from 'vue'
import axios from 'axios'

const machines = ref()

const getNMachines = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + "/home/getNMachines", {params: {groupId: props.group.id }})
    .then((res) => {
      if(res.data.ok){
        machines.value = res.data.num
      }else {

      }
    })
}

onMounted(() => {
  getNMachines()
})

const props = defineProps({
  group: Object 
});

</script>

<template>
  <div class="small-box color-title-1 color-light-blue border-blue-1">
    <div class="inner text-black-alpha-80">
      <h3>{{ machines }}</h3>
      <p class="text-gray-1">Proxmox VMachines</p>
    </div>
    <div class="icon text-black-alpha-80">
      <i class="pi pi-desktop"></i>
    </div>
    <router-link v-slot="{ href, navigate }" to="/vmachines" custom>
      <a :href="href" @click="navigate" class="small-box-footer text-black-alpha-70">
        VMachines <i class="fas fa-arrow-circle-right"></i>
      </a>
    </router-link>
  </div>
</template>

<style scoped>
@import 'admin-lte/dist/css/adminlte.css';
@import 'admin-lte/plugins/fontawesome-free/css/all.min.css';
</style>