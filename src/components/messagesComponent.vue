<script setup>
import { ref, inject } from 'vue'
import axios from 'axios'

const messageDialogApp = inject('messageDialog')
const loading = inject('loading')
const toast = inject('toast')

// Send Message
const messageDialog = ref(true)
const message = ref()



const sendMessage = () => {
  // let chatId = "719358840"
  // let chatId = "-4039164347"
  axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/telegram/send-message", {token: window.$cookies.get("auth"), message: message.value})
    .then((res) => {
      if(res.data) {
        toast.toast('success', 'Message sent succesfully!', '')
        // toast.add({ severity: 'success', summary: 'Message sent succesfully!', detail: '', life: 4000 });
        message.value = ""
        // messageDialog.value = false
        window.location.reload()
      }else {
        toast.toast('error', 'Error sending the message.', '')
        // toast.add({ severity: 'error', summary: 'Error sending the message.', detail: '', life: 4000 });
      }
    })
    .catch(error => {
      console.error("Error al enviar la solicitud:", error);
    });
}
</script>

<template>
  <Dialog v-model:visible="messageDialog" modal :closable="false" :style="{ width: '50rem' }" 
    :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
    <!-- HEADER -->
    <template #header>
      <div class="flex align-items-center">
        <i class="pi pi-telegram" style="font-size: 2.5rem"></i>
        <b class="text-2xl ml-2">Send Telegram Message</b>
      </div>
    </template>
    <!-- MAIN CONTENT -->

    <div class="mt-4">
      <div class="card flex ml-2 mr-5 mt-4">
        <span class="p-float-label w-full">
          <Textarea v-model="message" autoResize rows="7" cols="30" class="w-full" />
          <label for="description">Message</label>
        </span>
      </div>
    </div>
    <!-- FOOTER -->
    <template #footer>
      <div class="flex justify-content-center gap-2 w-full">
        <Button label="Cancel" icon="pi pi-times" @click="messageDialogApp.update()" class="surface-300 border-400 text-black-alpha-90"/>
        <Button label="Send" icon="pi pi-send" @click="sendMessage" />
      </div>
    </template>
  </Dialog>
</template>