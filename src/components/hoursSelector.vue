<template>
  <div class="card flex justify-content-center">
    <Button type="button" icon="pi pi-clock" label="Select Time" @click="toggle" class="color-light-blue-2 text-blue-500 border-blue-400" />

    <OverlayPanel ref="op">
      <div class="flex w-12rem">
        <table class="w-full text-center">
          <tr>
            <td><label for="hoursInput">Hours</label></td>
            <td><label for="hoursInput">Minutes</label></td>
          </tr>
          <tr>
            <td>
              <InputNumber v-model="item.hours" showButtons buttonLayout="vertical" style="width: 3rem" :min="0" :max="99" class="p-inputnumber-button-up:color-1">
                <template #incrementbuttonicon>
                  <span class="pi pi-plus" />
                </template>
                <template #decrementbuttonicon>
                  <span class="pi pi-minus" />
                </template>
              </InputNumber>
            </td>
            <td>
              <InputNumber v-model="item.minutes" showButtons buttonLayout="vertical" style="width: 3rem" :min="0" :max="59">
                <template #incrementbuttonicon>
                  <span class="pi pi-plus" />
                </template>
                <template #decrementbuttonicon>
                  <span class="pi pi-minus" />
                </template>
              </InputNumber>
            </td>
          </tr>
        </table>
      </div>
    </OverlayPanel>

  </div>
</template>

<script setup>
import { ref, defineProps } from "vue";

const props = defineProps({
  item: Object // Definiendo la prop username
});

const op = ref();

const toggle = (event) => {
  op.value.toggle(event);
}
</script>

<style scoped>
table {
  width: 100%;
}

td {
  text-align: center;
  vertical-align: middle;
}
</style>