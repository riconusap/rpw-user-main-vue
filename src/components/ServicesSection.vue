<template>
  <section
    data-aos="fade-right"
    data-aos-duration="1000"
    id="service"
  >
    <div class="container-fluid pt-5 pb-3">
      <div class="container">
        <div class="row">
          <div
            class="col-lg-12 mb-5"
            data-aos="fade-right"
            data-aos-duration="1500"
          >
            <h1 class="mt-2 mb-3">OUR EXPERTISE</h1>
            <h4 class="font-weight-normal text-muted mb-4 text-justify">
              Besides providing legal services from set up a new company, contract drafting and negotiation, we also provide legal advice and represent company in securing its business deals and resolve their legal problem. 
              <br>
              <br>
              R. Prama Wijaya & Partners services are included to arrange a legal structure of reorganizing or restructuring business. This might be sale or purchase assets or business, a merger or set up joint venture and company spinning-off. In protecting intellectual property right, our service is not only preceding the application of patent, trademark and copyright registration but also representing client in legal dispute on intellectual property matters whether through litigation, arbitration or mediation.
            </h4>
            <RouterLink
              to="/services"
              class="btn btn-primary py-md-2 px-md-4 font-weight-semi-bold"
            >Discover More</RouterLink>
          </div>
          <div
            class="col-lg-12"
            data-aos="fade-right"
            data-aos-duration="2000"
          >
            <div
              v-if="loading"
              class="text-center py-5"
            >
              <div
                class="spinner-border text-primary"
                role="status"
              >
                <span class="sr-only">Loading...</span>
              </div>
            </div>
            <div
              v-else-if="features.length > 0"
              class="row"
            >
              <div
                v-for="feature in features"
                :key="feature.id"
                class="col-md-6 mb-5"
              >
                <div class="d-flex">
                  <div class="feature-icon mr-3">
                    <!-- Display image if icon_image_url exists -->
                    <img
                      v-if="feature.icon_image_url"
                      :src="getImageUrl(feature.icon_image_url, 'icons')"
                      :alt="feature.title"
                      class="feature-icon-img"
                    />
                    <!-- Display Font Awesome icon if no image -->
                    <i
                      v-else
                      :class="feature.icon"
                      class="fa-3x text-primary"
                    ></i>
                  </div>
                  <div class="d-flex flex-column">
                    <h5 class="font-weight-bold mb-3">{{ feature.title }}</h5>
                    <p>{{ feature.description }}</p>
                  </div>
                </div>
              </div>
            </div>
            <div
              v-else
              class="alert alert-info"
            >
              No featured practice areas available. Please add and mark practice areas as featured in the admin panel.
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from "vue";
import { supabase, getImageUrl } from "@/lib/supabase";

interface PracticeArea {
  id: string;
  title: string;
  description: string;
  icon: string;
  icon_image_url?: string;
  order_position: number;
}

export default defineComponent({
  name: "ServicesSection",
  setup() {
    const loading = ref(true);
    const features = ref<PracticeArea[]>([]);

    const loadFeatures = async () => {
      try {
        const { data, error } = await supabase
          .from("practice_areas")
          .select("*")
          .eq("is_active", true)
          .eq("is_featured", true)
          .order("order_position", { ascending: true });

        if (error) throw error;
        features.value = data || [];
      } catch (error) {
        console.error("Error loading practice areas:", error);
      } finally {
        loading.value = false;
      }
    };

    onMounted(() => {
      loadFeatures();
    });

    return {
      loading,
      features,
      getImageUrl,
    };
  },
});
</script>

<style scoped>
.feature-icon {
  min-width: 60px;
  display: flex;
  align-items: flex-start;
  justify-content: center;
}

.feature-icon-img {
  width: 60px;
  height: 60px;
  object-fit: contain;
}
</style>
