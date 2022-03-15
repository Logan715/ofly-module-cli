<template>
  <div>
    <BaseItemAvailableRelaButton
      :tag-code="tagCode"
      class="mr-mini"
      @handle-finished="handleFinished"
    />
    <el-button-group class="mr-mini">
      <KeyItemProvinceBatchSubmitButton 
        :select-rows="selectRows" 
        @handle-finished="handleFinished"
      />
      <KeyItemProvinceBatchWithdrawButton 
        :select-rows="selectRows" 
        @handle-finished="handleFinished"
      />
    </el-button-group>
    <KeyItemProvinceContinueTodoButton 
      :tag-code="tagCode"
    />
    <KeyItemProvinceExportSelectColumnButton
      :tag-code="tagCode"
      :condition="condition"
    />
    <KeyItemProvinceReviewImportButton v-if="admin" :tag-code="tagCode" />
    
  </div>
</template>
<script>
import BaseItemAvailableRelaButton from "@/modules/BaseItem/BaseItemAvailable/BaseItemAvailableRela/BaseItemAvailableRelaButton.vue";
import KeyItemProvinceBatchSubmitButton from "./KeyItemProvinceBatch/KeyItemProvinceBatchSubmitButton.vue"
import KeyItemProvinceBatchWithdrawButton from "./KeyItemProvinceBatch/KeyItemProvinceBatchWithdrawButton.vue"
import KeyItemProvinceContinueTodoButton from "../../KeyItemProvinceContinue/KeyItemProvinceContinueTodo/KeyItemProvinceContinueTodoButton.vue"
import KeyItemProvinceExportSelectColumnButton from './KeyItemProvinceExportSelectColumnButton.vue'
import KeyItemProvinceReviewImportButton from '../../KeyItemProvinceReview/KeyItemProvinceReviewImportButton.vue'
import {isThemeAdmin} from '@/utils/UserUtil'
import { THEME } from '@/modules/Theme/KeyItemProvince/core/index'
export default {
  components: {
    BaseItemAvailableRelaButton,
    KeyItemProvinceBatchSubmitButton,
    KeyItemProvinceBatchWithdrawButton,
    KeyItemProvinceContinueTodoButton,
    KeyItemProvinceExportSelectColumnButton,
    KeyItemProvinceReviewImportButton
  },
  props: {
    tagCode: String,
    selectRows: {
      type: Array,
      default() {return []}
    },
    condition: {
      type: Object,
      default() {return {}}
    }
  },
  data() {
    return {
      admin: isThemeAdmin(THEME)
    }
  },
  methods: {
    handleFinished() {
      this.$emit('handle-finished')
    }
  }
}
</script>