<template>
  <div id="app">
    <p>{{ displaySeconds }}</p>
    <form>
      <input type='number' v-model="numberOfSets" />
      <input type='number' v-model="setDuration" />
      <input type='number' v-model="cooldownDuration" />
    </form>
    <button @click="startRunning">Go</button>
  </div>
</template>

<script>
export default {
  name: "App",
  data: function () {
    return {
      displaySeconds: 5,
      workoutList: [],
      numberOfSets: 10,
      setDuration: 10,
      cooldownDuration: 10,
      running: false,
      x: null,
    };
  },
  mounted: function () {
    this.x = setInterval(function () {
      if (this.running) {
        if (this.displaySeconds < 1) {
          if (this.workoutList.length > 0) {
            this.displaySeconds = this.workoutList.shift();
          } else {
            this.running = false;
            this.displaySeconds = 'Done';
            return;
          }
        }
        this.displaySeconds--;
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
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
