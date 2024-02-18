import { openDB } from 'idb';

const dbPromise = openDB('accounting', 1, {
  upgrade(db) {
    db.createObjectStore('rights', { autoIncrement: false, keyPath: 'groupId' });
  },
});

export default {
  async agregarDato(dato) {
    const db = await dbPromise;
    const tx = db.transaction('rights', 'readwrite');
    const store = tx.objectStore('rights');
    const exist = await store.get(dato.groupId);
    if (!exist) {
      await store.add(dato);
    }
  },
  async obtenerDatos(groupId) {
    const db = await dbPromise;
    const tx = db.transaction('rights', 'readonly');
    const store = tx.objectStore('rights');
    return store.get(groupId);
  },
  async deleteDatabase() {
    await indexedDB.deleteDatabase('accounting')
  }
};
