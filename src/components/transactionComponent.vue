<script setup>
import { ref, inject } from 'vue'
import axios from 'axios'


const group = inject('selectedGroup')

// Dialog
const transactionDialog = ref(true);
const dialogSelected = ref('Add Funds');
const dialogOptions = ref(['Add Funds', 'Withdraw Funds']);

// Transaction
const fundsAmount = ref()
const fundsTitle = ref("")
const fundsDescription = ref("")
const fundsChecked = ref(false)
const currentDate = new Date()
const formatDate = ref(currentDate.getFullYear()+"-"+(parseInt(currentDate.getMonth())+1)+"-"+currentDate.getDate())
const fundsDate = ref(formatDate)
const titleInvalid = ref(false)
const amountInvalid = ref(false)
const descriptionInvalid = ref(false)

const transactionDialogApp = inject('transactionDialog')
const loading = inject('loading')
const toast = inject('toast')


// CLOSE TRANSACTION DATA DIALOG
const closeTransactionDialog = () => {
  transactionDialogApp.update()
  // transactionDialog.value = false;
  /* const currentRoute = router.currentRoute.value;
  router.push({ path: currentRoute.path });   */
}


// SUBMIT TRANSACTION DATA
const submitTransaction = () => {
  if(fundsAmount.value == 0 || fundsAmount.value == null || fundsTitle.value == "" || fundsDescription.value == ""){
    // If some field is empty, WARNING!
    toast.toast('warn', 'Warning!', 'Fill all gaps.')
    // toast.add({ severity: 'warn', summary: 'Warning!', detail: 'Fill all gaps.', life: 4000 });
    // Put invalid field
    amountInvalid.value = fundsAmount.value == 0 || fundsAmount.value == null || fundsAmount.value == undefined ? true : false;
    titleInvalid.value = fundsTitle.value == "" ? true : false;
    descriptionInvalid.value = fundsDescription.value == "" ? true : false;
  }else{
    // If all fields aren't empty
    let date = new Date(fundsDate.value)
    let formatDate = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
    let object = {title: fundsTitle.value, description: fundsDescription.value, amount: fundsAmount.value, date: formatDate,
                  groupId: group.data.value.id, token: window.$cookies.get('auth')};

    if(dialogSelected.value!='Add Funds'){
      // If Withdraw Founds, put in negative
      object.amount = object.amount*-1
    }
    loading.load(true)
    axios.post(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/setTransaction', object)
      .then((res) => {
        loading.load(false)
        if(res.data.ok){
          // Put 0 / null all fields
          fundsAmount.value = null
          fundsTitle.value = ""
          fundsDescription.value = ""
          // Success toast
          toast.toast('success', 'Transaction Correctly!', 'The transaction was saved correctly.')
          // toast.add({ severity: 'success', summary: 'Transaction Correctly!', detail: 'The transaction was saved correctly.', life: 4000 });
          // Close Dialog
          transactionDialog.value = false;
          window.location.reload()
        }else{
          toast.toast('error', 'Transaction Error!', 'The transaction couldn\'t be completed.')
          // toast.add({ severity: 'error', summary: 'Transaction Error!', detail: 'The transaction couldn\'t be completed.', life: 4000 });
          console.error(res.data.msg)
        }
      })
  }
}

// RESET TRANSACTION DATE (CURRENT DATE)
const changeChecked = () => {
  if(fundsChecked.value == false){
    formatDate.value = currentDate.getFullYear()+"-"+(parseInt(currentDate.getMonth())+1)+"-"+currentDate.getDate()
  }
}


</script>

<template>

<Dialog v-model:visible="transactionDialog" modal :closable="false" :style="{ width: '50rem' }" 
:breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
  <!-- HEADER -->
  <template #header>
    <div class="flex align-items-center">
      <i class="pi pi-chart-line" style="font-size: 1.5rem"></i>
      <b class="text-2xl ml-2">Transaction</b>
    </div>
  </template>
  <!-- MAIN CONTENT -->
  <div class="card flex justify-content-center mt-1">
    <SelectButton v-model="dialogSelected" :options="dialogOptions" aria-labelledby="basic" />
  </div>

  <div class="mt-4">
    <div class="card flex">
      <span class="col-7 p-float-label">
        <InputText :class="{ 'p-invalid': titleInvalid }" v-model="fundsTitle" class="w-full" />
        <label class="pl-2" for="title">Title</label>
      </span>
      <span class="col-4 p-float-label">
        <InputNumber :class="{'p-invalid': amountInvalid}" v-model="fundsAmount" :minFractionDigits="0" :maxFractionDigits="2" mode="currency" currency="EUR" locale="de-DE" 
          class="w-full" />
        <label for="amount" 
          :class="['pl-2 flex align-items-center', dialogSelected === 'Add Funds' ? 'text-green-400' : 'text-red-400']">
          <i class="pi pi-euro mr-2" style="font-size: 1rem"></i>
          Amount
        </label>
      </span>
    </div>
    <div class="card flex ml-2 mr-5 mt-4">
      <span class="p-float-label w-full">
        <Textarea :class="{ 'p-invalid': descriptionInvalid }" v-model="fundsDescription" autoResize rows="5" cols="30" class="w-full" />
        <label for="description">Description</label>
      </span>
    </div>
    <div class="card flex ml-2 mr-5 mt-4 justify-content-right align-items-center">
      <label for="changeDate" class="flex align-items-center"><i class="pi pi-calendar" style="font-size: 1.5rem"></i>Change date</label>
      <InputSwitch v-model="fundsChecked" @change="changeChecked" class="ml-2" />
    </div>
    <div v-if="fundsChecked==true" class="card flex ml-2 mr-5 mt-2 justify-content-right">
      <Calendar v-model="fundsDate" dateFormat="yy-mm-dd" />
    </div >
  </div>
  <!-- FOOTER -->
  <template #footer>
    <div class="flex justify-content-center w-full gap-3">
      <Button label="Cancel" icon="pi pi-times" @click="closeTransactionDialog" class="surface-300 border-400 text-black-alpha-90"/>
      <Button label="Submit" icon="pi pi-upload" @click="submitTransaction" :class="[dialogSelected=='Add Funds' ? 'bg-green-500 border-green-600' : 'bg-red-500 border-red-600']"/>
    </div>
  </template>
</Dialog>
</template>