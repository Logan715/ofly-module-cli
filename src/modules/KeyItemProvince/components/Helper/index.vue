<template>
  <PolicyAttachment :theme="theme" class="helper" />
</template>

<script>
import PolicyAttachment from '@/modules/components/PolicyAttachment/index.vue'
import {THEME} from '@/modules/Theme/KeyItemProvince/core/index'
export default {
  components: {
    PolicyAttachment
  },
  data() {
    return {
      theme: THEME
    }
  },
}
</script>
<style lang="less" scoped>
.helper {
  height: 388px;
}
</style>