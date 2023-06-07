import { LightningElement, track } from 'lwc';
import fetchRandomDogImage from '@salesforce/apex/DogImageController.fetchRandomDogImage';
//import { refreshApex } from '@salesforce/apex';

export default class DogImageAPI extends LightningElement {
    @track dogImageUrl;
    //@track wiredResult;

    connectedCallback() {
        this.fetchNewImage();
    }

    fetchNewImage() {
        console.log('Inside FetchNewImage');
        this.dogImageUrl = null;
        //refreshApex(this.wiredResult) // Refresh the cache
        fetchRandomDogImage({ uniqueParam: Date.now() }) // Append unique query parameter
            .then(result => {
                console.log('Result', result);
                this.dogImageUrl = result;
            })
            .catch(error => {
                console.error('Error fetching dog image:', error);
            })
    }
}