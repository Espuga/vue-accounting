import { createApp } from 'vue'
import App from './App.vue'
import router from './router/router'
import { VueCookies } from 'vue-cookies'
import ConfirmationService from 'primevue/confirmationservice';
import './styles/style.css'

// Import PrimeFlex
import '../node_modules/primeflex/primeflex.css'                       // PrimeFlex
import '../node_modules/primeicons/primeicons.css'                     // icons

// Admin-LTE
// import 'admin-lte/dist/css/adminlte.css'
// import 'admin-lte/plugins/fontawesome-free/css/all.min.css'
import 'admin-lte/dist/js/adminlte.min.js'
import 'admin-lte/plugins/fastclick/fastclick.js'
import 'admin-lte/plugins/bootstrap/js/bootstrap.bundle.min.js'

// Importing Prime VUE and themes
import PrimeVue from 'primevue/config'
import Menubar from 'primevue/menubar';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import Dialog from 'primevue/dialog';
import Button from 'primevue/button';
import Toast from 'primevue/toast';
import ToastService from 'primevue/toastservice';
import SelectButton from 'primevue/selectbutton';
import InputNumber from 'primevue/inputnumber';
import InputText from 'primevue/inputtext';
import Textarea from 'primevue/textarea';
import InputSwitch from 'primevue/inputswitch';
import Calendar from 'primevue/calendar';
import Card from 'primevue/card';
import Dropdown from 'primevue/dropdown';
import SplitButton from 'primevue/splitbutton';
import Divider from 'primevue/divider';
import Panel from 'primevue/panel';
import DataView from 'primevue/dataview';
import DataViewLayoutOptions from 'primevue/dataviewlayoutoptions'
import ConfirmDialog from 'primevue/confirmdialog';
import ProgressSpinner from 'primevue/progressspinner';
import Password from 'primevue/password';
import Checkbox from 'primevue/checkbox';


import "primevue/resources/themes/lara-light-blue/theme.css";
import "primevue/resources/primevue.min.css";


const app = createApp(App)

app.component('Menubar', Menubar);
app.component('DataTable', DataTable);
app.component('Column', Column);
app.component('Dialog', Dialog);
app.component('Button', Button);
app.component('Toast', Toast);
app.component('SelectButton', SelectButton);
app.component('InputNumber', InputNumber);
app.component('InputText', InputText);
app.component('Textarea', Textarea);
app.component('InputSwitch', InputSwitch);
app.component('Calendar', Calendar);
app.component('Card', Card);
app.component('Dropdown', Dropdown);
app.component('SplitButton', SplitButton);
app.component('Divider', Divider);
app.component('Panel', Panel);
app.component('DataView', DataView);
app.component('DataViewLayoutOptions', DataViewLayoutOptions);
app.component('ConfirmDialog', ConfirmDialog);
app.component('ProgressSpinner', ProgressSpinner);
app.component('Password', Password);
app.component('Checkbox', Checkbox);


app.use(PrimeVue)
app.use(router)
app.use(ToastService)
app.use(VueCookies, { expires: '1d' })
app.use(ConfirmationService)

app.mount('#app')
