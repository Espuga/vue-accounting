<script setup>
import { onMounted, ref, defineProps } from "vue";
import axios from "axios"

const money = ref()
const formatMoney = ref()

const getMoney = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/home/getHome', { params: { groupId: props.group.id } })
    .then((res) => {
      if(res.data.ok){
        money.value = res.data.amount.toFixed(2)
        formatMoney.value = res.data.amount.toFixed(2).toString().replace(".", ",")
        let splitet = formatMoney.value.split(',')
        let formatet = ""
        let x = 0
        for(let i = splitet[0].length-1; i >= 0; i--) {
          if(x%3==0 && x != 0){
            formatet = "." + formatet
          }
          x++
          formatet = splitet[0][i] + formatet
        }
        formatMoney.value = formatet+","+splitet[1]
      }
    })
}

onMounted(() => {
  getMoney()
})

const props = defineProps({
  group: Object 
});


</script>

<template>
  <!-- <div :class="{'small-box text-white': true, 'color-light-green-2': money>0, 'color-light-red-2': money<0 }"> -->
  <div class="small-box" :class="{'color-light-green border-green-1': money>0, 'color-light-red border-red-1': money<0}">
    <div class="inner" :class="{'text-light-green': money>0, 'text-light-red':money<0}">
      <h3 >{{ formatMoney }} €</h3>
      <p class="text-black-alpha-70">Accounting {{ props.group.name }}</p>
    </div>
    <div class="icon text-black-alpha-80">
      <i class="pi pi-chart-bar"></i>
    </div>
    <router-link v-slot="{ href, navigate }" to="/accounting/dashboard" custom>
      <a :href="href" @click="navigate" class="small-box-footer text-black-alpha-70">
        Dashboard <i class="fas fa-arrow-circle-right"></i>
      </a>
    </router-link>
  </div>
</template>

<style scoped>
@import 'admin-lte/dist/css/adminlte.css';
@import 'admin-lte/plugins/fontawesome-free/css/all.min.css';
</style>