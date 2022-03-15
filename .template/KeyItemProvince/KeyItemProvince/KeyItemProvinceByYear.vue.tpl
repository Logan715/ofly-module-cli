<script>
import ${KeyItemProvince} from './index.vue'
export default {
  extends: ${KeyItemProvince},
  props: {
    multipleYear: {
      type: Boolean,
      default: false,
    },
    year: {
      type: String,
      required: true,
    },
  }
}
</script>