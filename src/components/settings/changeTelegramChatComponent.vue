<script setup>
import { ref, inject } from 'vue'
import axios from 'axios'

const loading = inject('loading')
const toast = inject('toast')

const visibleChangeTelegram = ref(false)
const chatId = ref(null)

const getChatId = () => {
  if(chatId.value == null) {
    axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/settings/getChatId")
      .then((res) => {
        if(res.data.ok) {
          chatId.value = res.data.chatId
        }else {
          toast.toast('error', 'Error!', 'Error getting the Chat ID.')
        }
      })
  }
}

const saveChatId = () => {
  if(chatId.value != null && chatId.value != ""){
    axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/settings/saveChatId", chatId.value)
      .then((res) => {
        if(res.data) {
          toast.toast('success', 'Saved!', 'Chat ID saved successfully.')
          visibleChangeTelegram.value = false
        }else {
          toast.toast('error', 'Error!', 'Error saving the Chat ID.')
        }
      })
      .catch((err) => {
        console.error(err)
      })
  }
}

</script>

<template>
  <div class="ml-6 flex justify-content-between align-items-center mt-4">
    <div class="flex align-items-center">
      <i class="pi pi-telegram" style="font-size: 2rem"></i>
      <span class="ml-2">Change Telegram Chat ID</span>
    </div>
    <Button @click="visibleChangeTelegram=true; getChatId();" label="Change" class="color-light-blue-2 text-blue-500 border-blue-600 w-2" />
    <!-- DIALOG CHANGE TELEGRAM CHAT ID -->
    <Dialog v-model:visible="visibleChangeTelegram" modal @keyup.esc="visibleChangeTelegram=false" :closable="false" :style="{ width: '30rem' }" 
      :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
      <!-- HEADER DIALOG CHANGE TELEGRAM CHAT ID -->
      <template #header>
        <div class="flex align-items-center">
          <i class="pi pi-telegram" style="font-size: 1.5rem"></i>
          <b class="text-2xl ml-2">Change Telegram Chat ID</b>
        </div>
      </template>
      <!-- CONTENT DIALOG CHANGE TELEGRAM CHAT ID -->
      <div class="p-4 color-1 shadow-3 border-round-xl">
        <!-- GROUP NAME & STRATING AMOUNT -->
        <span class="col-12">
          <label for="chatId">Chat ID</label>
          <InputText v-model="chatId" class="w-full mt-1" autofocus @keyup.enter="saveChatId()" />
        </span>
      </div>
      <!-- FOOTER DIALOG CHANGE TELEGRAM CHAT ID -->
      <template #footer>
        <div class="flex justify-content-center w-full gap-3">
          <Button label="Cancel" icon="pi pi-times" @click="visibleChangeTelegram = false" class="opacity-80 surface-200 border-400 color-1 text-black-alpha-90"/>
          <Button label="Submit" icon="pi pi-save" @click="saveChatId()" class="color-light-green text-green-500 border-green-600"/>
        </div>
      </template>
    </Dialog>
  </div>
</template>