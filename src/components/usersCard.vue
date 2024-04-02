<script setup>
import { ref, onMounted, defineProps } from 'vue'
import axios from 'axios'

const getNMachines = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/settings/getUsers', { params: { groupId: props.group.id } } )
    .then((res) => {
      if(res.data.ok){
        usersList.value = res.data.users
      }else{
        toast.add({ severity: 'error', summary: 'Error!', detail: 'An error occurred while getting users. Try it again.', life: 3000 });
      }
    })
}

const usersList = ref([])



onMounted(() => {
  getNMachines()
})

const props = defineProps({
  group: Object 
});

</script>

<template>
  <div class="small-box color-light-yellow border-yellow-1">
    <div class="inner text-black-alpha-80">
      <h3>{{ props.group.nom }}'s users</h3>
      <!-- <p>Proxmox VMachines</p> -->
    </div>
    <div class="icon text-black-alpha-80">
      <i class="pi pi-users"></i>
    </div>
    <div class="mx-3 mb-2">
      <div v-for="(user, index) in usersList">
        <Divider class="my-2 w-6 color-title-1" v-if="index !== 0"/>
        <div class="flex">
          <img v-if="user.img != ''" class="border-circle" style="width: 1.7rem" :src="user.img" />
          <i v-else class="pi pi-user opacity-80" style="font-size: 1.5rem"></i>
          <div class="ml-2 "> 
            {{ user.name }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import 'admin-lte/dist/css/adminlte.css';
@import 'admin-lte/plugins/fontawesome-free/css/all.min.css';
</style>