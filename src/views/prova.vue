
<template>
  <div class="card">
    <!-- <Badge value="2"></Badge> -->
      <Menubar :model="items">
          <template #item="{ item, props, hasSubmenu, root }">
              <a v-ripple class="flex align-items-center" v-bind="props.action">
                  <span :class="item.icon" />
                  <span class="ml-2">{{ item.label }}</span>
                  <Badge v-if="item.badge" :class="{ 'ml-auto': !root, 'ml-2': root }" :value="item.badge" />
                  <span v-if="item.shortcut" class="ml-auto border-1 surface-border border-round surface-100 text-xs p-1">{{ item.shortcut }}</span>
                  <i v-if="hasSubmenu" :class="['pi pi-angle-down', { 'pi-angle-down ml-2': root, 'pi-angle-right ml-auto': !root }]"></i>
              </a>
          </template>
      </Menubar>
  </div>
</template>

<script setup>
import { ref } from "vue";

const items = ref([
  {
      label: 'Home',
      icon: 'pi pi-home'
  },
  {
      label: 'Features',
      icon: 'pi pi-star'
  },
  {
      label: 'Projects',
      icon: 'pi pi-search',
      items: [
          {
              label: 'Core',
              icon: 'pi pi-bolt',
              shortcut: '⌘+S'
          },
          {
              label: 'Blocks',
              icon: 'pi pi-server',
              shortcut: '⌘+B'
          },
          {
              label: 'UI Kit',
              icon: 'pi pi-pencil',
              shortcut: '⌘+U'
          },
          {
              separator: true
          },
          {
              label: 'Templates',
              icon: 'pi pi-palette',
              items: [
                  {
                      label: 'Apollo',
                      icon: 'pi pi-palette',
                      badge: 2
                  },
                  {
                      label: 'Ultima',
                      icon: 'pi pi-palette',
                      badge: 3
                  }
              ]
          }
      ]
  },
  {
      label: 'Contact',
      icon: 'pi pi-envelope',
      badge: 3
  }
]);
</script>
