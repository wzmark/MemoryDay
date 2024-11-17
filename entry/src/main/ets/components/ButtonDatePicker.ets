import router from '@ohos.router';


@Component

export struct ButtonOptionBox{

        @Prop title: string;


        @State text:string = ''
        @State date: string | Date = ''
        private selectedDate: Date = new Date('2021-08-08')

        build() {
                Row(){

                                DatePicker({
                                        start: new Date('1900-1-1'),
                                        end: new Date('2100-1-1'),
                                        selected: this.selectedDate
                                }).onChange((value: DatePickerResult) => {
                                        this.selectedDate.setFullYear(value.year as number, value.month as number, value.day as number)
                                        console.info('select current date is: ' + JSON.stringify(value))
                                })


                }.justifyContent(FlexAlign.SpaceBetween)


        }
}