<template>
  <el-button :disabled="!canWithdraw" @click="handleBatchWithdraw">
    批量撤回
  </el-button>
</template>
<script>
import { 
  FlowState
 } from "../../../core/index";
 import { ConfirmUtil } from '@newboss/nb-common'
 import { batchWithdraw } from '../../../api'
export default {
  props: {
    selectRows: {
      type: Array,
      default() {return []}
    }
  },
  computed: {
    batchWithdrawIds() {
      const todoAuditStatus = [
        FlowState.TODO_LEVEL_TO_LEVEL_AUDIT,
        FlowState.TODO_LEVEL_TO_LEVEL_AUDIT,
      ];
      return this.selectRows
        .filter(({ tagWfCurState }) => todoAuditStatus.includes(tagWfCurState))
        .map(({ itemTagId }) => itemTagId);
    },
    canWithdraw() {
      return this.batchWithdrawIds.length > 0;
    },
  },
  methods: {
    async batchWithdraw() {
      this.loading = true;
      try {
        await batchWithdraw(this.batchWithdrawIds);
        this.$message.success("撤回成功");
        this.$emit("handle-finished")
      } catch (e) {
        console.error(e);
      }
      this.loading = false;
    },
    handleBatchWithdraw() {
      ConfirmUtil(
        `确认<span class="nb-notice">撤回</span>【${this.batchWithdrawIds.length}】条项目？`,
        this.batchWithdraw
      );
    },
  }
}
</script>