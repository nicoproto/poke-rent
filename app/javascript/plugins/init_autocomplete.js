import places from 'places.js';

const initAutocomplete = () => {
  const addressInput = document.getElementById('pokemon_location');
  if (addressInput) {
    places({ container: addressInput });
  }
};

export { initAutocomplete };