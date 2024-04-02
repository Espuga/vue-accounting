<template>
    <div>
      <h2>IndexedDB Component</h2>
      <form @submit.prevent="agregarDato">
        <label>
          Nombre:
          <input v-model="nombre" required />
        </label>
        <label>
          Edad:
          <input type="number" v-model.number="edad" required />
        </label>
        <button type="submit">Agregar</button>
      </form>
      <ul>
        <li v-for="dato in datos" :key="dato.id">
          {{ dato.nombre }} - {{ dato.edad }} años
        </li>
      </ul>
    </div>
  </template>
  
  <script>
  import IndexedDBService from '../services/IndexedDBService';
  
  export default {
    data() {
      return {
        nombre: '',
        edad: 0,
        datos: [],
      };
    },
    methods: {
      async agregarDato() {
        await IndexedDBService.agregarDato({ nombre: this.nombre, edad: this.edad });
        this.actualizarDatos();
        this.nombre = '';
        this.edad = 0;
      },
      async actualizarDatos() {
        this.datos = await IndexedDBService.obtenerDatos();
      },
    },
    created() {
      this.actualizarDatos();
    },
  };
  </script>
  