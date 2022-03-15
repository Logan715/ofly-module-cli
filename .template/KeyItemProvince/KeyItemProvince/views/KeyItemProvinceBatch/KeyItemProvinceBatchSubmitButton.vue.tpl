<template>
  <el-button :disabled="!canSubmit" @click="handleBatchSubmit">
    批量提交
  </el-button>
</template>
<script>
import { 
  FlowState
 } from "../../../core/index";
 import { ConfirmUtil } from '@newboss/nb-common'
 import { batchSubmit } from '../../../api'
export default {
  props: {
    selectRows: {
      type: Array,
      default() {return []}
    }
  },
  computed: {
    batchSubmitIds() {
      return this.selectRows
        .filter(({ tagWfCurState }) => tagWfCurState === FlowState.TODO_SUBMIT)
        .map(({ itemTagId }) => itemTagId);
    },
    canSubmit() {
      return this.batchSubmitIds.length > 0;
    },
  },
  methods: {
    async batchSubmit() {
      this.loading = true;
      try {
        await batchSubmit(this.batchSubmitIds);
        this.$message.success("提交成功");
        this.$emit("handle-finished")
      } catch (e) {
        console.error(e);
      }
      this.loading = false;
    },
    handleBatchSubmit() {
      ConfirmUtil(
        `确认<span class="nb-notice">提交</span>【${this.batchSubmitIds.length}】条项目？`,
        this.batchSubmit
      );
    },
  }
}
</script>