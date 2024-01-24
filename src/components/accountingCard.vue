<script setup>
import { inject } from "vue";

const money = inject('money')
const group = inject('selectedGroup')


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
    <a href="/accounting/dashboard" class="small-box-footer">
      Dashboard <i class="fas fa-arrow-circle-right"></i>
    </a>
  </div>
</template>

<style scoped>
@import 'admin-lte/dist/css/adminlte.css';
@import 'admin-lte/plugins/fontawesome-free/css/all.min.css';
</style>