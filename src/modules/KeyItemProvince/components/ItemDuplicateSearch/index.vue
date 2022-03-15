<template>
  <CommonItemDuplicateSearch :theme="theme" />
</template>
<script>
import CommonItemDuplicateSearch from '@/modules/ItemDuplicate/components/ItemDuplicateSearch/index.vue'
import { THEME } from "@/modules/Theme/KeyItemProvince/core/index"
export default {
  components: {
    CommonItemDuplicateSearch
  },
  data() {
    return {
      theme: THEME
    }
  },
}
</script>