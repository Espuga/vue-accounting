<script setup>
// =============================
//          Import
import { ref, onMounted, inject, watch } from "vue";
import { useToast } from "primevue/usetoast";
import IndexedDBService from './../services/IndexedDBService'
import changeMembersComponent from "../components/settings/changeMembersComponent.vue";
import changeVlanComponent from "../components/settings/changeVlanComponent.vue";
import deleteGroupComponent from "../components/settings/deleteGroupComponent.vue";
import changeSprintPeriodsComponent from "../components/settings/changeSprintPeriodsComponent.vue";
import changeSalaryComponent from "../components/settings/changeSalaryComponent.vue";
import newGroupComponent from "../components/settings/newGroupComponent.vue";
import changeTelegramChatComponent from "../components/settings/changeTelegramChatComponent.vue";
import changeTelegramAlertChatComponent from "../components/settings/changeTelegramAlertChatComponent.vue";
import changeTeachersComponent from "../components/settings/changeTeachersComponent.vue";

// ============================= 
//          Const

// GLOBAL
const toast = useToast();
const loading = ref(false)


const admin = inject('isAdmin')
const isAdmin = ref(false)
const changeAdmin = () => {
  isAdmin.value = admin.data.value
}
watch(() => admin.data.value, changeAdmin);

// RIGHTS
const teacher = ref(false)





// =============================
//          Functions

const getRights = async () => {
  let rights = await IndexedDBService.obtenerDatos(0)
  if(rights != undefined){
    if(rights.rights.includes(2, 0)) {
      teacher.value = true
    } else {
      teacher.value = false
    }
  } else {
    teacher.value = false
  }
}

// ON MOUNTED
onMounted(() => {
  document.title = "Settings"
  isAdmin.value = admin.data.value
  getRights()
})

</script>

<template>
  <div class="card ml-8 mr-8 pl-8 pr-8 pt-4">
    <Card class="ml-8 mr-8 pl-8 pr-8 pt-4 pb-6 shadow-5 border-round-2xl color-0">
      <!-- SETTINGS TITLE -->
      <template #title>
        <div class="flex align-items-center mt-2">
          <i class="pi pi-cog mr-2" style="font-size: 2rem"></i>
          Settings 
        </div>
      </template>
      <!-- SETTINGS CONTENT -->
      <template #content>
        <div class="pl-8 pr-8">
          
          <!-- GROUP SETTINGS -->
          <div id="groupSettings" class="color-1 border-round-xl p-3 shadow-3">
            <div class="flex align-items-center">
                <h3>Group Settings</h3>
            </div>
            <!-- CHANGE MEMBERS -->
            <changeMembersComponent/>
            <!-- CHANGE VLAN -->
            <changeVlanComponent/>
            <!-- DELETE GROUP -->
            <deleteGroupComponent v-if="isAdmin || teacher"/>
          </div> <!-- FI GROUP SETTINGS -->

          <!-- GLOBAL SETTINGS -->
          <div v-if="teacher" id="groupSettings"  class="color-1 border-round-xl p-3 shadow-3 mt-5">
            <div class="flex align-items-center">
                <h3>Global Settings</h3>
            </div>
            <!-- CHANGE SPRINT PERIODS -->
            <changeSprintPeriodsComponent/>
            <!-- CHANGE SALARY -->
            <changeSalaryComponent/>
            <!-- NEW GROUP -->
            <newGroupComponent/>
            <!-- CHANGE TEACHERS -->
            <changeTeachersComponent/>
            <!-- CHANGE TELEGRAM CHAT ID -->
            <changeTelegramChatComponent/>
            <!-- CHANGE TELEGRAM ALERT CHAT ID -->
            <changeTelegramAlertChatComponent/>
          </div> <!-- FI GLOBAL SETTINGS -->
          
        </div><!-- FI DIV GENERAL DE CONFIG -->
      </template>
    </Card>

    <!-- CONFIRM DIALOG -->
    <ConfirmDialog group="headless">
      <template #container="{ message, acceptCallback, rejectCallback }">
        <div class="flex flex-column align-items-center p-5 surface-overlay border-round">
          <div class="border-circle bg-primary inline-flex justify-content-center align-items-center h-6rem w-6rem -mt-8">
            <i class="pi pi-question text-5xl"></i>
          </div>
          <span class="font-bold text-2xl block mb-2 mt-4">{{ message.header }}</span>
          <p class="mb-0">{{ message.message }}</p>
          <div class="flex align-items-center gap-2 mt-4">
            <Button label="Delete" @click="acceptCallback" class="w-8rem" autofocus></Button>
            <Button label="Cancel" outlined @click="rejectCallback" class="w-8rem"></Button>
          </div>
        </div>
      </template>
    </ConfirmDialog>
    <!-- TOAST -->
    <Toast/>
    <!-- LOADING PROGRESS SPINNER -->
    <Dialog v-model:visible="loading" header="Loading..." modal :closable="false">
      <ProgressSpinner />
    </Dialog>
  </div>
</template>
