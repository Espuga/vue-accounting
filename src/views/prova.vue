<template>
  <div class="card flex justify-content-center">
    <Button type="button" icon="pi pi-image" label="Image" @click="toggle" />

    <OverlayPanel ref="showOPanel">
      <div class="flex flex-column gap-3 w-25rem">
        TEST
      </div>
    </OverlayPanel>
  </div>
</template>

<script setup>
import { ref } from "vue";

const showOPanel = ref();

const toggle = (event) => {
  showOPanel.value.toggle(event);
}
</script>