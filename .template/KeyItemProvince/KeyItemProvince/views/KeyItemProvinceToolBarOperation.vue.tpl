<template>
  <div>
    <BaseItemAvailableRelaButton
      :tag-code="tagCode"
      class="mr-mini"
      @handle-finished="handleFinished"
    />
    <el-button-group class="mr-mini">
      <${KeyItemProvince}BatchSubmitButton 
        :select-rows="selectRows" 
        @handle-finished="handleFinished"
      />
      <${KeyItemProvince}BatchWithdrawButton 
        :select-rows="selectRows" 
        @handle-finished="handleFinished"
      />
    </el-button-group>
    <${KeyItemProvince}ContinueTodoButton 
      :tag-code="tagCode"
    />
    <${KeyItemProvince}ExportSelectColumnButton
      :tag-code="tagCode"
      :condition="condition"
    />
    <${KeyItemProvince}ReviewImportButton v-if="admin" :tag-code="tagCode" />
    
  </div>
</template>
<script>
import BaseItemAvailableRelaButton from "@/modules/BaseItem/BaseItemAvailable/BaseItemAvailableRela/BaseItemAvailableRelaButton.vue";
import ${KeyItemProvince}BatchSubmitButton from "./${KeyItemProvince}Batch/${KeyItemProvince}BatchSubmitButton.vue"
import ${KeyItemProvince}BatchWithdrawButton from "./${KeyItemProvince}Batch/${KeyItemProvince}BatchWithdrawButton.vue"
import ${KeyItemProvince}ContinueTodoButton from "../../${KeyItemProvince}Continue/${KeyItemProvince}ContinueTodo/${KeyItemProvince}ContinueTodoButton.vue"
import ${KeyItemProvince}ExportSelectColumnButton from './${KeyItemProvince}ExportSelectColumnButton.vue'
import ${KeyItemProvince}ReviewImportButton from '../../${KeyItemProvince}Review/${KeyItemProvince}ReviewImportButton.vue'
import {isThemeAdmin} from '@/utils/UserUtil'
import { THEME } from '@/modules/Theme/${KeyItemProvince}/core/index'
export default {
  components: {
    BaseItemAvailableRelaButton,
    ${KeyItemProvince}BatchSubmitButton,
    ${KeyItemProvince}BatchWithdrawButton,
    ${KeyItemProvince}ContinueTodoButton,
    ${KeyItemProvince}ExportSelectColumnButton,
    ${KeyItemProvince}ReviewImportButton
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