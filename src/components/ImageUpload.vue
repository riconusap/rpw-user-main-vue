<template>
  <div class="image-upload">
    <div class="upload-area" :class="{ 'has-image': imageUrl }">
      <div v-if="imageUrl" class="preview">
        <img :src="imageUrl" :alt="alt" @error="handleImageError" />
        <div class="overlay">
          <button type="button" @click="removeImage" class="btn-remove">
            <i class="fas fa-trash"></i>
          </button>
          <button type="button" @click="triggerUpload" class="btn-change">
            <i class="fas fa-sync"></i> Change
          </button>
        </div>
      </div>

      <div v-else class="upload-placeholder" @click="triggerUpload">
        <i class="fas fa-cloud-upload-alt"></i>
        <p>{{ placeholder }}</p>
        <span class="file-info">{{ acceptText }}</span>
      </div>

      <input
        ref="fileInput"
        type="file"
        :accept="accept"
        @change="handleFileChange"
        style="display: none"
      />
    </div>

    <div v-if="uploading" class="upload-progress">
      <div class="progress-bar">
        <div class="progress-fill" :style="{ width: `${uploadProgress}%` }"></div>
      </div>
      <span>{{ uploadProgress }}%</span>
    </div>

    <div v-if="error" class="upload-error">
      <i class="fas fa-exclamation-circle"></i>
      {{ error }}
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, watch, computed } from 'vue';
import { uploadImage, deleteImage, getImageUrl } from '@/lib/supabase';

export default defineComponent({
  name: 'ImageUpload',
  props: {
    modelValue: {
      type: String,
      default: '',
    },
    folder: {
      type: String,
      default: 'images',
    },
    bucket: {
      type: String,
      default: 'images',
    },
    accept: {
      type: String,
      default: 'image/jpeg,image/png,image/webp',
    },
    maxSize: {
      type: Number,
      default: 5, // MB
    },
    placeholder: {
      type: String,
      default: 'Click to upload image',
    },
    alt: {
      type: String,
      default: 'Uploaded image',
    },
  },
  emits: ['update:modelValue', 'uploaded', 'deleted'],
  setup(props, { emit }) {
    const fileInput = ref<HTMLInputElement>();
    const uploading = ref(false);
    const uploadProgress = ref(0);
    const error = ref('');
    const imageKey = ref(0); // Force re-render of image

    const acceptText = props.accept
      .split(',')
      .map(type => type.split('/')[1].toUpperCase())
      .join(', ');

    // Use computed property to cache image URL and prevent infinite loop
    // Add timestamp to force browser to reload the image after upload
    const imageUrl = computed(() => {
      if (props.modelValue) {
        const url = getImageUrl(props.modelValue, props.bucket);
        // Add cache-busting parameter with imageKey to force reload
        return `${url}?v=${imageKey.value}`;
      }
      return '';
    });

    const triggerUpload = () => {
      fileInput.value?.click();
    };

    const handleFileChange = async (event: Event) => {
      const target = event.target as HTMLInputElement;
      const file = target.files?.[0];

      if (!file) return;

      // Validate file size
      const sizeInMB = file.size / (1024 * 1024);
      if (sizeInMB > props.maxSize) {
        error.value = `File size must be less than ${props.maxSize}MB`;
        return;
      }

      // Validate file type
      if (!props.accept.includes(file.type)) {
        error.value = 'Invalid file type';
        return;
      }

      error.value = '';
      uploading.value = true;
      uploadProgress.value = 0;

      try {
        // Generate unique filename
        const timestamp = Date.now();
        const filename = `${timestamp}-${file.name}`;
        const path = `${props.folder}/${filename}`;

        // Simulate progress (Supabase doesn't provide real progress)
        const progressInterval = setInterval(() => {
          if (uploadProgress.value < 90) {
            uploadProgress.value += 10;
          }
        }, 100);

        // Upload to Supabase
        const { data, url } = await uploadImage(file, path, props.bucket);

        clearInterval(progressInterval);
        uploadProgress.value = 100;

        // Emit the storage path (not full URL)
        emit('update:modelValue', data.path);
        emit('uploaded', { path: data.path, url });

        // Force image refresh by updating key
        imageKey.value++;

        // Reset progress after a delay
        setTimeout(() => {
          uploading.value = false;
          uploadProgress.value = 0;
        }, 500);
      } catch (err: any) {
        error.value = err.message || 'Upload failed';
        uploading.value = false;
        uploadProgress.value = 0;
      }

      // Reset input
      target.value = '';
    };

    const removeImage = async () => {
      if (!props.modelValue) return;

      if (!confirm('Are you sure you want to delete this image?')) return;

      try {
        await deleteImage(props.modelValue, props.bucket);
        emit('update:modelValue', '');
        emit('deleted');
        imageKey.value++; // Force refresh
      } catch (err: any) {
        error.value = err.message || 'Delete failed';
      }
    };

    const handleImageError = (event: Event) => {
      const target = event.target as HTMLImageElement;
      // Prevent infinite loop by checking if already showing placeholder
      if (target.src.includes('placeholder.jpg')) {
        return;
      }
      // Hide the broken image instead of replacing with placeholder
      target.style.display = 'none';
      error.value = 'Failed to load image';
    };

    return {
      fileInput,
      imageUrl,
      uploading,
      uploadProgress,
      error,
      acceptText,
      triggerUpload,
      handleFileChange,
      removeImage,
      handleImageError,
    };
  },
});
</script>

<style scoped>
.image-upload {
  width: 100%;
}

.upload-area {
  border: 2px dashed #e2e8f0;
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.2s;
}

.upload-area:hover {
  border-color: #d4a948;
}

.upload-area.has-image {
  border-style: solid;
  border-color: #e2e8f0;
}

.preview {
  position: relative;
  width: 100%;
  height: 300px;
}

.preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  opacity: 0;
  transition: opacity 0.2s;
}

.preview:hover .overlay {
  opacity: 1;
}

.btn-remove,
.btn-change {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-remove {
  background: #ef4444;
  color: white;
}

.btn-remove:hover {
  background: #dc2626;
}

.btn-change {
  background: white;
  color: #1e293b;
}

.btn-change:hover {
  background: #f1f5f9;
}

.upload-placeholder {
  padding: 3rem 2rem;
  text-align: center;
  cursor: pointer;
  transition: background 0.2s;
}

.upload-placeholder:hover {
  background: #f8fafc;
}

.upload-placeholder i {
  font-size: 3rem;
  color: #d4a948;
  margin-bottom: 1rem;
}

.upload-placeholder p {
  font-size: 1rem;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.file-info {
  font-size: 0.875rem;
  color: #64748b;
}

.upload-progress {
  margin-top: 1rem;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.progress-bar {
  flex: 1;
  height: 8px;
  background: #e2e8f0;
  border-radius: 4px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: #d4a948;
  transition: width 0.3s;
}

.upload-error {
  margin-top: 0.75rem;
  padding: 0.75rem;
  background: #fee;
  color: #c00;
  border-radius: 8px;
  font-size: 0.875rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
</style>
