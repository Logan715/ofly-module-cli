<template>
  <div class="item-statistics">
    <StatisticsCard 
      v-for="(reportGroup, index) in reportGroups" 
      :key="reportGroup.group"
      :seq="index+1"
      :title="reportGroup.label"
      :data="reportGroup.children"
      @click="handleJumpPage"
    />
  </div>
</template>
<script>
import { PageJumpUtil } from '@newboss/nb-common'
import StatisticsCard from '@/modules/desktop/components/StatisticsCard/index.vue'
export default {
  components: {
    StatisticsCard
  },
  data() {
    return {
      reportGroups: [
        {label: '省重点统计', group: 'focus', children: [
          {label: '分级管理', value: "KeyItemProvinceByHierarchical"},
          {label: '行业统计', value: "KeyItemProvinceByProfession"},
          {label: '三大领域统计', value: "KeyItemProvinceByIndustry"},
          {label: '进展情况统计', value: "KeyItemProvinceInvestmentByResp"},
          {label: '进展填报监控', value: "KeyItemProvinceProgressMonitoring"},
        ]},
        {label: '重中之重统计', group: 'topPriority', children: [
          // {label: '投资滞后', value:undefined},
          // {label: '项目汇总', value:undefined},
          // {label: '项目查询', value:undefined},
        ]},
        {label: '赶超项目统计', group: 'catchUp', children: [
          // {label: '投资滞后', value:undefined},
          // {label: '赶超项目', value:undefined},
          // {label: '投资统计', value:undefined},
          // {label: '开工项目', value:undefined},
          // {label: '竣工项目', value:undefined},
          // {label: '调度监控', value:undefined},
          // {label: '项目查询', value:undefined},
        ]},
        {label: '五个一批', group: 'five', children: [

        ]},
      ]
    }
  },
  methods: {
    handleJumpPage(name) {
      name && PageJumpUtil.jump(name);
    }
  }
}
</script>
<style lang="less" scoped>
.item-statistics {
  display: flex;
}
</style>