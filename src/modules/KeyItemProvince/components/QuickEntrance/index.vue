<template>
  <div v-loading="loading" class="entrances">
    <EntranceCard 
      v-for="item in entrances" 
      :key="item.type" 
      :type="item.type"
      :label="item.label"
      :disabled="item.disabled"
      @click="handleClick(item)" 
    />
  </div>
</template>
<script>
import { PageJumpUtil } from '@newboss/nb-common'
import EntranceCard from "@/modules/desktop/components/EntranceCard/index.vue"
import { THEME } from '@/modules/Theme/KeyItemProvince/core/index'
import { getTagCodeList } from '@/modules/ItemTag/api'
export default {
  components: {
    EntranceCard
  },
  data() {
    return {
      loading: false,
      tagCodeList: [],
      entrances: [
        {label: '项目申报', type: 'declare'},
        {label: '调度填报', type: 'schedule'},
        {label: '问题登记', type: 'problem', disabled: true},
      ]
    }
  },
  computed: {
    tagCode() {
      const finder = this.tagCodeList?.find(({enable})=>enable);
      return finder?.tagCode
    }
  },
  mounted() {
    this.loadCommonResource();
  },
  methods: {
    async loadCommonResource() {
      this.loading = true;
      try {
        const tagCodeList = await getTagCodeList(THEME);
        this.tagCodeList = tagCodeList;
      } catch(e) {console.error(e);}
      this.loading = false;
    },
    handleClick({type}) {
      switch(type) {
        case 'declare':
          if(this.tagCode) {
            PageJumpUtil.jump('BaseItem', {jumpTimestamp: new Date().valueOf(), jumpParams: {
              tagCode: this.tagCode
            }},);
          } else {
            this.$message.error('没有有效的项目标签，无法申报');
          }
          break;
        case 'schedule':
          PageJumpUtil.jump('KeyItemProvinceSchedule');
          break;
        case 'problem':
          break;
          
      }
    }
  }
}
</script>
<style lang="less" scoped>
.entrances {
  display: flex;
  justify-content: space-between;
  padding: 24px 42px;
  &__item {
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
  }
  &__icon {
    height: 48px;
    width: 48px;
  }
  &__title {
    font-size: 14px;
    margin: 0 24px;
  }
  
}
</style>
