import flatpickr from "flatpickr";

const initFlatpickr = () => {
  const dateField = document.querySelector(".datepicker");
  if (dateField) {
    flatpickr(".datepicker", {});
  }
}

export { initFlatpickr };