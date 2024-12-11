export interface GooglePlace {
  placeId: string;
  fullAddress: string;
  longitude: string;
  latitude: string;
}

export enum GooglePlaceFields {
  placeId = 'placeId',
  fullAddress = 'fullAddress',
  longitude = 'longitude',
  latitude = 'latitude',
}
