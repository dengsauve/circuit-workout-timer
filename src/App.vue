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
          style="color: white; font-size: 30px; font-weight: bold"
        >
          {{ displaySeconds }}
        </v-progress-linear>

        <v-form :disabled="workoutList.length > 0">
          <v-row>
            <v-col cols="12">
              <v-subheader class="pl-0">number of sets</v-subheader>
              <v-slider min="0" max="30" v-model="numberOfSets" label="">
                <template v-slot:append>
                  <span style="white-space: nowrap">{{ numberOfSets }}</span>
                </template>
              </v-slider>
            </v-col>

            <v-col cols="12">
              <v-subheader class="pl-0">set duration</v-subheader>
              <v-slider
                min="0"
                max="120"
                v-model="setDuration"
              >
                <template v-slot:append>
                  <span style="white-space: nowrap">{{ setDuration }}</span>
                </template>
              </v-slider>
            </v-col>

            <v-col cols="12">
              <v-subheader class="pl-0">cooldown duration</v-subheader>
              <v-slider
                min="0"
                max="120"
                v-model="cooldownDuration"
              >
                <template v-slot:append>
                  <span style="white-space: nowrap">{{
                    cooldownDuration
                  }}</span>
                </template>
              </v-slider>
            </v-col>
          </v-row>
        </v-form>
        <v-btn
          v-if="!running"
          x-large 
          @click="startRunning" 
          color="success" 
          class="mr-5">
          <font color="white">START</font>
        </v-btn>
        <v-btn 
          v-if="running"
          x-large 
          @click="pauseRunning" 
          color="warning" 
          class="mr-5">
          <font color="white">PAUSE</font>
        </v-btn>
        <v-btn 
          x-large 
          @click="reset" 
          color="error" 
          class="mr-5">
          <font color="white">RESET</font>
        </v-btn>

        <v-footer absolute class="font-weight-medium">
          <v-col class="text-center" cols="12">
            Built with ♥️ for a healthier life by
            <strong
              ><a href="https://github.com/dengsauve" target="_blank"
                >dengsauve</a
              ></strong
            >
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
      numberOfSets: 15,
      setDuration: 90,
      cooldownDuration: 30,
      running: false,
      x: null,
      bellSounds: new Audio("audio/bell.mp3"),
      wowSounds: new Audio("audio/wow.mp3"),
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
              if (this.workingOut) this.wowSounds.play();
              this.workingOut = !this.workingOut;
              this.displaySeconds = this.workoutList.shift();
              this.displayColor = this.workingOut ? "success" : "primary";
            } else {
              this.running = false;
              this.displaySeconds = "Done";
              this.bellSounds.play();
              return;
            }
          }
        }
      }.bind(this),
      1000
    );

    this.loadLastSettings();
  },

  watch: {
    numberOfSets: function (newValue, oldValue) {
      localStorage.numberOfSets = newValue;
    },
    setDuration: function (newValue, oldValue) {
      localStorage.setDuration = newValue;
    },
    cooldownDuration: function (newValue, oldValue) {
      localStorage.cooldownDuration = newValue;
    },
  },

  methods: {
    startRunning: function () {
      if (this.workoutList.length > 0) {
        this.running = true;
        return
      }
      this.running = true;
      this.workingOut = true;

      this.displaySeconds = this.setDuration;

      for (let i = 0; i < this.numberOfSets; i++) {
        this.workoutList.push(this.setDuration, this.cooldownDuration);
      }

      this.workoutList.shift();

      this.bellSounds.play();
    },

    pauseRunning: function () {
      this.running = !this.running;
    },

    reset: function () {
      this.running = false;
      this.workoutList = [];
      this.displaySeconds = 0;
      this.displayColor = "success";
    },

    loadLastSettings: function () {
      if (localStorage.numberOfSets)
        this.numberOfSets = localStorage.numberOfSets;
      if (localStorage.setDuration) this.setDuration = localStorage.setDuration;
      if (localStorage.cooldownDuration)
        this.cooldownDuration = localStorage.cooldownDuration;
    },
  },
};
</script>

<style>
</style>
