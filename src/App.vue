<template>
    <v-app>

      <v-app-bar app>
        <v-app-bar-title>Circuit Training Timer</v-app-bar-title>
      </v-app-bar>

      <v-main>
        <v-container class="text-center">

          <v-progress-linear
            class="mt-5 mb-10"
            rounded
            reverse
            :value="progressPercentage" 
            height="50"
            :color="displayColor"
            >
            {{ displaySeconds }}
          </v-progress-linear>


          <v-form>
            <v-slider 
              min="0" 
              max="30"
              v-model="numberOfSets"
              label="number of sets"
            >
                          <template v-slot:append>
                <span style="white-space: nowrap;">{{ numberOfSets }}</span>
              </template>
            </v-slider>
            <v-slider 
              min="0" 
              max="120" 
              v-model="setDuration"
              label="set duration"
            >
                            <template v-slot:append>
                <span style="white-space: nowrap;">{{ setDuration }}</span>
              </template>
            </v-slider>
            <v-slider 
              min="0"
              max="120"
              v-model="cooldownDuration"
              label="cooldown duration"
              >
              <template v-slot:append>
                <span style="white-space: nowrap;">{{ cooldownDuration }}</span>
              </template>
            </v-slider>
          </v-form>
          <v-btn x-large @click="startRunning" color="success"><font color="white">START</font></v-btn>
        </v-container>
      </v-main>
    </v-app>
</template>

<script>
export default {
  name: "App",
  data: function () {
    return {
      displaySeconds: 5,
      displayColor: 'success',
      workoutList: [],
      numberOfSets: 10,
      setDuration: 10,
      cooldownDuration: 10,
      running: false,
      x: null,
    };
  },

  computed: {
    progressPercentage: function () {
      return 100 * this.displaySeconds / this.setDuration;
    }
  },

  mounted: function () {
    this.x = setInterval(function () {
      if (this.running) {
        this.displaySeconds--;
        if (this.displaySeconds === 5) {
          this.displayColor = 'error'
        }
        if (this.displaySeconds < 0) {
          if (this.workoutList.length > 0) {
            this.displaySeconds = this.workoutList.shift();
            this.displayColor = 'success'
          } else {
            this.running = false;
            this.displaySeconds = 'Done';
            return;
          }
        }
      }
    }.bind(this), 1000);
  },

  methods: {
    startRunning: function () {
      this.running = !this.running;

      this.displaySeconds = this.setDuration;

      for (let i = 0; i < this.numberOfSets; i++) {
        this.workoutList.push(this.setDuration, this.cooldownDuration);
      }

      this.workoutList.shift();

      console.log(
        this.numberOfSets,
        this.setDuration,
        this.cooldownDuration,
        this.displaySeconds,
        this.workoutList
      );
    },
  },
};
</script>

<style>
</style>
