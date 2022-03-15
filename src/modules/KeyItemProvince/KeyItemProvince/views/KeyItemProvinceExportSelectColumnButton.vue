<template>
  <el-button @click="visible=true">
    选列导出
    <ExportSelectColumnModal 
      v-loading="loading"
      :visible.sync="visible" 
      :columns="columns"
      :select-columns.sync="selectColumns"
      @download="downloadExcel"
    />
  </el-button>
    
</template>
<script>
import ExportSelectColumnModal from '@/modules/components/ExportSelectColumnModal/index.vue'
import { 
  getExportExcelAllowId, 
  downloadUrlBySelectColumns, 
  getExportColumns } from '../../api'
export default {
  components: {
    ExportSelectColumnModal
  },
  props: {
    tagCode: String,
    condition: {
      type: Object,
      default: ()=>({})
    }
  },
  data() {
    return {
      visible: false,
      loading: false,
      columns: [],
      selectColumns: [],
    }
  },
  watch: {
    visible(val) {
      if(val && !this.columns.length) {
        this.loadData();
      }
    }
  },
  methods: {
    async loadData() {
      this.loading = true;
      try {
        const columns = await getExportColumns(this.tagCode);
        this.columns = columns;
        this.selectColumns = columns.map(({value})=> value);
      } catch(e) {console.error(e);}
      this.loading = false;
    },
    async downloadExcel() {
      this.loading = true;
      try {
        const allowId = await getExportExcelAllowId({
          ...this.condition,
          tagCode: this.tagCode
        }, this.selectColumns);
        const url = downloadUrlBySelectColumns(allowId)
        window.open(url);
      } catch(e) {console.error(e);}
      this.loading = false;
    },
  }
}
</script>