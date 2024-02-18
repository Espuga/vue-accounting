<script setup>
import { inject, onMounted, ref, watch } from "vue";
import axios from "axios"

const money = ref()
const group = inject('selectedGroup')

const getMoney = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/getHome', { params: { groupId: group.data.value.id } })
    .then((res) => {
      if(res.data.ok){
        money.value = res.data.amount
      }
    })
}

onMounted(() => {
  getMoney()
})

watch(() => group.data.value, getMoney);

</script>

<template>
  <div :class="{'small-box': true, 'bg-green': money>0, 'bg-red': money<0 }">
    <div class="inner">
      <h3>{{ money }} €</h3>
      <p>Accounting {{ group.data.value.name }}</p>
    </div>
    <div class="icon">
      <i class="pi pi-chart-bar"></i>
    </div>
    <router-link v-slot="{ href, navigate }" to="/accounting/dashboard" custom>
      <a :href="href" @click="navigate" class="small-box-footer">
        Dashboard <i class="fas fa-arrow-circle-right"></i>
      </a>
    </router-link>
  </div>
</template>

<style scoped>
@import 'admin-lte/dist/css/adminlte.css';
@import 'admin-lte/plugins/fontawesome-free/css/all.min.css';
</style>