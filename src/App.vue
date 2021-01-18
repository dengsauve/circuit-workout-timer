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
              <span style="white-space: nowrap">{{ numberOfSets }}</span>
            </template>
          </v-slider>
          <v-slider
            min="0"
            max="120"
            v-model="setDuration"
            label="set duration"
          >
            <template v-slot:append>
              <span style="white-space: nowrap">{{ setDuration }}</span>
            </template>
          </v-slider>
          <v-slider
            min="0"
            max="120"
            v-model="cooldownDuration"
            label="cooldown duration"
          >
            <template v-slot:append>
              <span style="white-space: nowrap">{{ cooldownDuration }}</span>
            </template>
          </v-slider>
        </v-form>
        <v-btn x-large @click="startRunning" color="success" class="mr-5"
          ><font color="white">START</font></v-btn
        >
        <v-btn x-large @click="pauseRunning" color="warning" class="mr-5"
          ><font color="white">PAUSE</font></v-btn
        >
        <v-btn x-large @click="reset" color="error" class="mr-5"
          ><font color="white">RESET</font></v-btn
        >

        <v-footer absolute class="font-weight-medium">
          <v-col class="text-center" cols="12">
            Built with ♥️ for a healthier life by <strong><a href="https://github.com/dengsauve" target="_blank">dengsauve</a></strong>
          </v-col>
        </v-footer>

      </v-container>
    </v-main>
  </v-app>
</template>

<script>
export default {
  name: "App",
  data: function () {
    return {
      displaySeconds: 0,
      displayColor: "success",
      workingOut: false,
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
      return (100 * this.displaySeconds) / this.setDuration;
    },
  },

  mounted: function () {
    this.x = setInterval(
      function () {
        if (this.running) {
          this.displaySeconds--;
          if (this.displaySeconds === 5) {
            this.displayColor = "error";
          }
          if (this.displaySeconds < 0) {
            if (this.workoutList.length > 0) {
              this.workingOut = !this.workingOut;
              this.displaySeconds = this.workoutList.shift();
              this.displayColor = this.workingOut ? "success" : "primary";
            } else {
              this.running = false;
              this.displaySeconds = "Done";
              return;
            }
          }
        }
      }.bind(this),
      1000
    );
  },

  methods: {
    startRunning: function () {
      this.running = true;
      this.workingOut = true;

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

    pauseRunning: function () {
      this.running = !this.running;
    },

    reset: function () {
      this.running = false;
      this.workoutList = [];
      this.displaySeconds = 0;
    },
  },
};
</script>

<style>
</style>
