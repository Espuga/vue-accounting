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
        message.value = ""
        // messageDialog.value = false
        window.location.reload()
      }else {
        toast.toast('error', 'Error sending the message.', '')
      }
    })
    .catch(error => {
      console.error("Error al enviar la solicitud:", error);
    });
}
</script>

<template>
  <Dialog v-model:visible="messageDialog" modal @keyup.esc="messageDialogApp.update()" :closable="false" :style="{ width: '50rem' }" 
    :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
    <!-- HEADER -->
    <template #header>
      <div class="flex align-items-center">
        <i class="pi pi-telegram" style="font-size: 2.5rem"></i>
        <b class="text-2xl ml-2">Send Telegram Message</b>
      </div>
    </template>
    <!-- MAIN CONTENT -->

    <div class="py-3 shadow-2 color-0 border-round-xl flex justify-content-center align-items-center">
      <div class="card col-11 flex ">
        <span class="w-full">
          <label for="description">Message</label>
          <Textarea v-model="message" autoResize rows="7" cols="30" class="w-full mt-1" autofocus/>
        </span>
      </div>
    </div>
    <!-- FOOTER -->
    <template #footer>
      <div class="flex justify-content-center gap-2 w-full">
        <Button label="Cancel" icon="pi pi-times" @click="messageDialogApp.update()" class="opacity-80 shadow-3 surface-200 border-400 text-black-alpha-90"/>
        <Button label="Send" icon="pi pi-send" @click="sendMessage" class="color-light-blue-2 shadow-3 text-blue-500 border-blue-600" />
      </div>
    </template>
  </Dialog>
</template>