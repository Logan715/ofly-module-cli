<template>
  <div class="opeartion">
    <el-button type="text" @click="handleCommand(RowOperation.EDIT)">编辑</el-button>
    <template>
      <el-dropdown v-if="moreOperation" class="more" @command="handleCommand"> 
        <el-button type="text">更多<i class="el-icon-arrow-down el-icon--right"></i></el-button>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item 
            v-for="({ label, operationKey, danger,divided }) in availableOperations" 
            :key="operationKey" 
            :command="operationKey"
            :divided="divided"
          >
            <span :class="['el-button--text', {'nb-notice': danger}]">{{ label }}</span>
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
      <el-button v-else-if="singleOperation" type="text" :class="{'nb-notice': singleOperation.danger}" @click="handleCommand(singleOperation.operationKey)">{{ singleOperation.label }}</el-button>
    </template>
    <!-- <el-button type="text" :class="{'nb-hidden': !auth[RowOperation.SUSPENSION]}" @click="handleQuit(row)">退库</el-button> -->
    <!-- <el-button type="text" :class="['nb-notice', {'nb-hidden': !auth[RowOperation.DELETE]}]" @click="handleQuit(row)">删除</el-button> -->
  </div>
</template>
<script>
import { existFunction } from '@/utils/MenuUtil'
import { MenuFunction } from '@/modules/constant'
import { RowOperation } from '../config'
import { ConfirmUtil } from '@newboss/nb-common'
export default {
  props: {
    data: {
      type: Object,
      default(){return {}}
    },
    menuFuncList: {
      type: Array,
      default:()=> []
    },
  },
  data() {
    return {
      RowOperation
    }
  },
  computed: {
    auth() {
      return {
        [RowOperation.REVIEW]: this.data?.auth?.canReview,
        [RowOperation.DELETE]: this.data?.auth?.canDelete, 
      }
    },
    operations() {
      return [
        {label: "评审", operationKey : RowOperation.REVIEW, available: this.auth[RowOperation.REVIEW] },
        {label: "删除", operationKey : RowOperation.DELETE, available: this.auth[RowOperation.DELETE], danger: true, divided: true },
      ]
    },
    availableOperations() {
      return this.operations.filter(({available})=>available);
    },
    operationCount() {
      return this.availableOperations.length ;
    },
    moreOperation(){
      return this.operationCount > 1
    },
    singleOperation() {
      return this.operationCount === 1?this.availableOperations[0]: undefined
    }
    
    
  },
  methods: {
    handleCommand(operationKey) {
      switch(operationKey) {
        case RowOperation.DELETE: 
          this.handleDelete();
          break;
          default:
          this.$emit('handle-operation', operationKey, this.data);
      }
    },
   
    handleDelete() {
      ConfirmUtil(
        `确认<span class="nb-notice">删除</span>【${
          this.data.itemName || ""
        }】项目？`,
        ()=> this.$emit('handle-operation', RowOperation.DELETE, this.data)
      )
    }
  }
}
</script>
<style lang="less" scoped>
.opeartion {
  .more {
    margin-left: 10px;
  }
}
</style>