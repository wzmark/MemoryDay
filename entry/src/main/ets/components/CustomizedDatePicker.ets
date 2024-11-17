import router from '@ohos.router';
export interface Params{
        click: (value: Date) => void
}

@Component

export struct CustomizedDatePicker{

        @Prop onButtonClick: Params;
        @Link date: Date;
        private selectedDate: Date = new Date('2021-08-08')

        build() {
                Row(){
                        DatePicker({
                                start: new Date('1970-1-1'),
                                end: new Date('2100-1-1')
                        }).onDateChange((value: Date) => {
                                this.selectedDate.setTime(value.getTime())
                                this.onButtonClick.click(value)
                                //console.log(this.date.toDateString())


                        }).disappearTextStyle({color: '#ffffff'})
                }.width('100%').backgroundColor('#676666')


        }
}