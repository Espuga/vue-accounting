<script setup>
  import { ref, onMounted } from 'vue';

  import { use } from "echarts/core";
  import { CanvasRenderer } from "echarts/renderers";
  import { LineChart, BarChart } from "echarts/charts";
  import {
    TitleComponent,
    TooltipComponent,
    ToolboxComponent,
    LegendComponent,
    GridComponent,
  } from "echarts/components";
  // import VChart from "vue-echarts";
  import axios from 'axios';
  import { format } from 'date-fns';


  use([
    CanvasRenderer,
    LineChart,
    BarChart,
    TitleComponent,
    TooltipComponent,
    LegendComponent,
    GridComponent,
    ToolboxComponent
  ]);

  const startDate = ref();
  const endDate = ref();
  const priceCpu = ref(2);
  const priceMaxdisk = ref(0.56);

  const dataTable22 = ref();
  const priceCpu22 = ref(0)
  const sumMaxDisk22 = ref()
  const priceMaxDisk22 = ref()

  const dataTable23 = ref();
  const priceCpu23 = ref(0)
  const sumMaxDisk23 = ref()
  const priceMaxDisk23 = ref()

  const dataTable24 = ref();
  const priceCpu24 = ref(0)
  const sumMaxDisk24 = ref()
  const priceMaxDisk24 = ref()

  const optionChangeoverYears = ref();
  const optionCpus = ref();
  const optionMaxDisk = ref();

  const visible22 = ref(false);
  const visible23 = ref(false);
  const visible24 = ref(false);

  const getData = () => {
    const start = format(startDate.value, 'yyyy-MM-dd');
    const end = format(endDate.value, 'yyyy-MM-dd');
    if(priceCpu.value != "" && priceMaxdisk.value != ""){
      axios.get(import.meta.env.VUE_APP_BACKEND_IP + '/proxmox/getInit', {params: {start: start, end: end, priceCpu: priceCpu.value, priceDisk: priceMaxdisk.value}})
        .then(res => {
          if(res.data.ok){
            priceCpu22.value = 0
            priceCpu23.value = 0
            priceCpu24.value = 0
            // Dades taula
            dataTable22.value = res.data.tableVlan22;
            dataTable23.value = res.data.tableVlan23;
            dataTable24.value = res.data.tableVlan24;
            // Suma cpu amb preu
            dataTable22.value.forEach((row) => {
              priceCpu22.value += row.cpus*row.cpu*priceCpu.value;
            })
            dataTable23.value.forEach((row) => {
              priceCpu23.value += row.cpus*row.cpu*priceCpu.value;
            })
            dataTable24.value.forEach((row) => {
              priceCpu24.value += row.cpus*row.cpu*priceCpu.value;
            })
            priceCpu22.value = Math.round((priceCpu22.value) * Math.pow(10, 2)) / Math.pow(10, 2);
            priceCpu23.value = Math.round((priceCpu23.value) * Math.pow(10, 2)) / Math.pow(10, 2);
            priceCpu24.value = Math.round((priceCpu24.value) * Math.pow(10, 2)) / Math.pow(10, 2);
            // Suma MaxDisk sense preu
            sumMaxDisk22.value = res.data.sumDisk22;
            sumMaxDisk23.value = res.data.sumDisk23;
            sumMaxDisk24.value = res.data.sumDisk24;
            // Suma MaxDisk amb preu
            priceMaxDisk22.value = Math.round((res.data.sumDisk22*priceMaxdisk.value) * Math.pow(10, 2)) / Math.pow(10, 2);
            priceMaxDisk23.value = Math.round((res.data.sumDisk23*priceMaxdisk.value) * Math.pow(10, 2)) / Math.pow(10, 2);
            priceMaxDisk24.value = Math.round((res.data.sumDisk24*priceMaxdisk.value) * Math.pow(10, 2)) / Math.pow(10, 2);
          }
        })
    }
    /*axios.get(import.meta.env.VUE_APP_BACKEND_IP + '/proxmox/getCpuUsage', {params: {start: start, end: end}})
      .then(res => {
        if(res.data.ok){
          optionChangeoverYears.value.xAxis.data = res.data.dies;
          optionChangeoverYears.value.legend.data = []
          optionChangeoverYears.value.series = []
          res.data.maquines.forEach((maquina) => {
            optionChangeoverYears.value.legend.data.push(maquina.nom)
            optionChangeoverYears.value.series.push({
              name: maquina.nom,
              type: 'line',
              data: maquina.valor
            })// Fi push
          })
          
        }
      })*/
  }

  onMounted(() => {
    document.title = "VMachines"
    optionChangeoverYears.value = {
      title: {
        text: ''
      },
      tooltip: {
        trigger: 'axis'
      },
      legend: {
        data: [],
        top: '6%'
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
      },
      xAxis: {
        type: 'category',
        data: []
      },
      yAxis: {
        type: 'value'
      },
      series: []
    };
    optionCpus.value = {
      xAxis: {
        type: 'category',
        data: ['Linux', 'Windows', 'CM10', 'TrueNas', 'HomeAssistant', 'Pnet', 'Linux']
      },
      yAxis: {
        type: 'value'
      },
      series: [
        {
          data: [4, 12, 8, 6, 4, 4, 2],
          type: 'bar'
        }
      ]
    };
    optionMaxDisk.value = {
      xAxis: {
        type: 'category',
        data: ['Linux', 'Windows', 'CM10', 'TrueNas', 'HomeAssistant', 'Pnet', 'Linux']
      },
      yAxis: {
        type: 'value'
      },
      series: [
        {
          data: [48, 64, 48, 32, 32, 16, 24],
          type: 'bar'
        }
      ]
    };
    let today = new Date()
    endDate.value = today
    const dateAgo = new Date(today);
    dateAgo.setDate(today.getDate() - 21);
    startDate.value = dateAgo;
    getData()
  });

  const cahngeDate = () => {
    if(startDate.value && endDate.value){
    
      getData()
    }
  }

  /* const changePriceCpu = (price) => {
    priceCpu22.value = 0
    priceCpu23.value = 0
    priceCpu24.value = 0
    dataTable22.value.forEach((row) => {
      priceCpu22.value += row.cpus*row.cpu*price.value;
    })
    dataTable23.value.forEach((row) => {
      priceCpu23.value += row.cpus*row.cpu*price.value;
    })
    dataTable24.value.forEach((row) => {
      priceCpu24.value += row.cpus*row.cpu*price.value;
    })
    priceCpu22.value = Math.round((priceCpu22.value) * Math.pow(10, 2)) / Math.pow(10, 2);
    priceCpu23.value = Math.round((priceCpu23.value) * Math.pow(10, 2)) / Math.pow(10, 2);
    priceCpu24.value = Math.round((priceCpu24.value) * Math.pow(10, 2)) / Math.pow(10, 2);
  } */
  /* const changePriceDisk = (price) => {
    priceMaxDisk22.value = Math.round((sumMaxDisk22.value*price.value) * Math.pow(10, 2)) / Math.pow(10, 2);
    priceMaxDisk23.value = Math.round((sumMaxDisk23.value*price.value) * Math.pow(10, 2)) / Math.pow(10, 2);
    priceMaxDisk24.value = Math.round((sumMaxDisk24.value*price.value) * Math.pow(10, 2)) / Math.pow(10, 2);
  } */

  const updateData = () => {
    /* const start = format(startDate.value, 'yyyy-MM-dd');
    const end = format(endDate.value, 'yyyy-MM-dd'); */

    console.log(priceCpu.value)

    /* dataTable22.value.forEach((registre) => {
      console.log(registre)
    }) */

    /* if(priceCpu.value != "" && priceMaxdisk.value != ""){
      axios.get(import.meta.env.VUE_APP_BACKEND_IP + '/proxmox/getInit', {params: {start: start, end: end, priceCpu: priceCpu.value, priceDisk: priceMaxdisk.value}})
        .then((res) => {
          if(res.data.ok){
            console.log(res.data)
          }
        })
    } */

  }
</script>

<template>
  <div class="grid">
    <!-- <div class="col-12 border-1 border-solid surface-border border-round bg-primary-500 text-white font-bold text-center text-6xl">
      Proxmox
    </div> -->
    <!-- Selectors -->
    <div class="col-12 grid bg-white border-round-xl justify-content-center">
      <div class="col-3 grid">
        <div class="col-12">Start Date</div>
        <Calendar @date-select="cahngeDate" v-model="startDate" dateFormat="yy-mm-dd" class="col-12 w-full"/>
      </div>
      <div class="col-3 grid">
        <div class="col-12">End Date</div>
        <Calendar @date-select="cahngeDate" v-model="endDate" dateFormat="yy-mm-dd" class="col-12 w-full"/>
      </div>
      <div class="col-3 grid">
        <div class="col-12">CPU Price (<b>€</b> / <b>%</b> CPU)</div>
        <InputNumber v-model="priceCpu" @input="updateData" :minFractionDigits="0" :maxFractionDigits="2" inputId="integeronly" class="col-12 w-full" />
      </div>
      <div class="col-3 grid">
        <div class="col-12">Disk Price (<b>€</b> / <b>GB</b>)</div>
        <InputNumber v-model="priceMaxdisk" @input="updateData" :minFractionDigits="0" :maxFractionDigits="2" inputId="integeronly" class="col-12 w-full" />
      </div>
    </div>
    <!-- <div class="col-12 grid">
      <div class="col-4 text-center text-2xl font-bold p-2 bg-primary-300 border-1 border-solid surface-border border-round">VLAN 22</div>
      <div class="col-4 text-center text-2xl font-bold p-2 bg-primary-300 border-1 border-solid surface-border border-round">VLAN 23</div>
      <div class="col-4 text-center text-2xl font-bold p-2 bg-primary-300 border-1 border-solid surface-border border-round">VLAN 24</div>
    </div> -->
    <!-- Taules -->
    <div class="col-12 grid bg-white border-round-xl mt-3">
      <div class="col-4 card p-0">
        <div class="col-12">
          <DataTable :value="dataTable22" paginator :rows="5" tableStyle="min-width: 10rem" class="p-datatable-header border-1 border-solid surface-border border-round">
            <template #header>
                <div class="flex flex-wrap align-items-center justify-content-between gap-2 p-2 bg-primary-300 border-1 border-solid surface-border border-round w-full">
                    <span class="text-xl text-900 font-bold ">VLAN 22</span>
                    <Button label="More" @click="visible22 = true" class="p-2"/>
                </div>
            </template>
            <Column field="vmid" header="VMID" headerClass="bg-primary-100" sortable></Column>
            <Column field="hostname" header="Hostname" headerClass="bg-primary-100"></Column>
            <Column field="cpu" header="CPU" headerClass="bg-primary-100" sortable></Column>
            <Column field="cpus" header="CPUs" headerClass="bg-primary-100" sortable></Column>
            <Column field="maxdisk" header="MaxDisk" headerClass="bg-primary-100" sortable></Column>
          </DataTable>
          <Dialog v-model:visible="visible22" modal header="VLAN 22" :style="{ width: '70%' }" >
            <DataTable :value="dataTable22" paginator :rows="10" tableStyle="min-width: 10rem" class="p-datatable-header border-1 border-solid surface-border border-round">
                <Column field="vmid" header="VMID" headerClass="bg-primary-100" sortable></Column>
                <Column field="hostname" header="Hostname" headerClass="bg-primary-100"></Column>
                <Column field="cpu" header="CPU" headerClass="bg-primary-100" sortable></Column>
                <Column field="cpus" header="CPUs" headerClass="bg-primary-100" sortable></Column>
                <Column field="maxdisk" header="MaxDisk" headerClass="bg-primary-100" sortable></Column>
                <Column field="cpuPrice" header="€ CPU" headerClass="bg-primary-100" sortable></Column>
                <Column field="diskPrice" header="€ Disk" headerClass="bg-primary-100" sortable></Column>
            </DataTable>
          </Dialog>
        </div>
        <div class="col-12 grid text-center">
          <div class="col-6">Price CPU: <b>{{ priceCpu22 }}€</b></div>
          <div class="col-6">Price Disk: <b>{{ priceMaxDisk22 }}€</b></div>
        </div>
      </div>
      <Divider layout="vertical" class="m-0" />
      <div class="col-4 card p-0">
        <div class="col-12">
          <DataTable :value="dataTable23" paginator :rows="5" tableStyle="min-width: 10rem" class="p-datatable-header border-1 border-solid surface-border border-round">
            <template #header>
                <div class="flex flex-wrap align-items-center justify-content-between gap-2 p-2 bg-primary-300 border-1 border-solid surface-border border-round w-full">
                    <span class="text-xl text-900 font-bold ">VLAN 23</span>
                    <Button label="More" @click="visible23 = true" class="p-2"/>
                </div>
            </template>
            <Column field="vmid" header="VMID" headerClass="bg-primary-100" sortable></Column>
            <Column field="hostname" header="Hostname" headerClass="bg-primary-100"></Column>
            <Column field="cpu" header="CPU" headerClass="bg-primary-100" sortable></Column>
            <Column field="cpus" header="CPUs" headerClass="bg-primary-100" sortable></Column>
            <Column field="maxdisk" header="MaxDisk" headerClass="bg-primary-100" sortable></Column>
          </DataTable>
          <Dialog v-model:visible="visible23" modal header="VLAN 22" :style="{ width: '70%' }" >
            <DataTable :value="dataTable23" paginator :rows="10" tableStyle="min-width: 10rem" class="p-datatable-header border-1 border-solid surface-border border-round">
                <Column field="vmid" header="VMID" headerClass="bg-primary-100" sortable></Column>
                <Column field="hostname" header="Hostname" headerClass="bg-primary-100"></Column>
                <Column field="cpu" header="CPU" headerClass="bg-primary-100" sortable></Column>
                <Column field="cpus" header="CPUs" headerClass="bg-primary-100" sortable></Column>
                <Column field="maxdisk" header="MaxDisk" headerClass="bg-primary-100" sortable></Column>
                <Column field="cpuPrice" header="€ CPU" headerClass="bg-primary-100" sortable></Column>
                <Column field="diskPrice" header="€ Disk" headerClass="bg-primary-100" sortable></Column>
            </DataTable>
          </Dialog>
        </div>
        <div class="col-12 grid text-center">
          <div class="col-6">Price CPU: <b>{{ priceCpu23 }}€</b></div>
          <div class="col-6">Price Disk: <b>{{ priceMaxDisk23 }}€</b></div>
        </div>
      </div>
      <Divider layout="vertical" class="m-0" />
      <div class="col-4 card p-0">
        <div class="col-12">
          <DataTable :value="dataTable24" paginator :rows="5" tableStyle="min-width: 10rem" class="p-datatable-header border-1 border-solid surface-border border-round">
            <template #header>
                <div class="flex flex-wrap align-items-center justify-content-between gap-2 p-2 bg-primary-300 border-1 border-solid surface-border border-round w-full">
                    <span class="text-xl text-900 font-bold ">VLAN 24</span>
                    <Button label="More" @click="visible24 = true" class="p-2"/>
                </div>
            </template>
            <Column field="vmid" header="VMID" headerClass="bg-primary-100" sortable></Column>
            <Column field="hostname" header="Hostname" headerClass="bg-primary-100"></Column>
            <Column field="cpu" header="CPU" headerClass="bg-primary-100" sortable></Column>
            <Column field="cpus" header="CPUs" headerClass="bg-primary-100" sortable></Column>
            <Column field="maxdisk" header="MaxDisk" headerClass="bg-primary-100" sortable></Column>
          </DataTable>
          <Dialog v-model:visible="visible24" modal header="VLAN 22" :style="{ width: '70%' }" >
            <DataTable :value="dataTable24" paginator :rows="10" tableStyle="min-width: 10rem" class="p-datatable-header border-1 border-solid surface-border border-round">
                <Column field="vmid" header="VMID" headerClass="bg-primary-100" sortable></Column>
                <Column field="hostname" header="Hostname" headerClass="bg-primary-100"></Column>
                <Column field="cpu" header="CPU" headerClass="bg-primary-100" sortable></Column>
                <Column field="cpus" header="CPUs" headerClass="bg-primary-100" sortable></Column>
                <Column field="maxdisk" header="MaxDisk" headerClass="bg-primary-100" sortable></Column>
                <Column field="cpuPrice" header="€ CPU" headerClass="bg-primary-100" sortable></Column>
                <Column field="diskPrice" header="€ Disk" headerClass="bg-primary-100" sortable></Column>
            </DataTable>
          </Dialog>
        </div>
        <div class="col-12 grid text-center">
          <div class="col-6">Price CPU: <b>{{ priceCpu24 }}€</b></div>
          <div class="col-6">Price Disk: <b>{{ priceMaxDisk24 }}€</b></div>
        </div>
      </div>
    </div>

    <!-- Grafics CPU -->
    
    <!-- <div class="col-12 text-center font-bold text-2xl p-2 bg-primary-300 border-1 border-solid surface-border border-round">CPU Usage (%/day)</div>    
      <div class="col-12 grid">
        <div class="col-4 card">      
          <div class="responsive border-1 border-solid surface-border border-round" style="height: 50vh; clientHeight: 40vh">
            <v-chart class="chart" :option="optionChangeoverYears" @click="click" autoresize/>
          </div>
        </div>
        <div class="col-4 card">      
          <div class="responsive border-1 border-solid surface-border border-round" style="height: 50vh; clientHeight: 40vh">
            <v-chart class="chart" :option="optionChangeoverYears" @click="click" autoresize/>
          </div>
        </div>
        <div class="col-4 card">      
          <div class="responsive border-1 border-solid surface-border border-round" style="height: 50vh; clientHeight: 40vh">
            <v-chart class="chart" :option="optionChangeoverYears" @click="click" autoresize/>
          </div>
        </div>
    </div> -->

    <!-- Grafics CPUs -->
    <!-- <div class="col-12 text-center font-bold text-2xl p-2 bg-primary-300 border-1 border-solid surface-border border-round">CPUs</div>
    <div class="col-12 grid">
      <div class="col-4 card">      
        <div class="responsive border-1 border-solid surface-border border-round" style="height: 50vh; clientHeight: 40vh">
          <v-chart class="chart" :option="optionCpus" @click="click" autoresize/>
        </div>
      </div>
      <div class="col-4 card">      
        <div class="responsive border-1 border-solid surface-border border-round" style="height: 50vh; clientHeight: 40vh">
          <v-chart class="chart" :option="optionCpus" @click="click" autoresize/>
        </div>
      </div>
      <div class="col-4 card">      
        <div class="responsive border-1 border-solid surface-border border-round" style="height: 50vh; clientHeight: 40vh">
          <v-chart class="chart" :option="optionCpus" @click="click" autoresize/>
        </div>
      </div>
    </div> -->

    <!-- Grafics MaxDisk -->
    <!-- <div class="col-12 text-center font-bold text-2xl p-2 bg-primary-300 border-1 border-solid surface-border border-round">Disk Space</div>
    <div class="col-12 grid">
      <div class="col-4 card">      
        <div class="responsive border-1 border-solid surface-border border-round" style="height: 50vh; clientHeight: 40vh">
          <v-chart class="chart" :option="optionMaxDisk" @click="click" autoresize/>
        </div>
      </div>
      <div class="col-4 card">      
        <div class="responsive border-1 border-solid surface-border border-round" style="height: 50vh; clientHeight: 40vh">
          <v-chart class="chart" :option="optionMaxDisk" @click="click" autoresize/>
        </div>
      </div>
      <div class="col-4 card">      
        <div class="responsive border-1 border-solid surface-border border-round" style="height: 50vh; clientHeight: 40vh">
          <v-chart class="chart" :option="optionMaxDisk" @click="click" autoresize/>
        </div>
      </div>
    </div> -->


  </div>
  
</template>