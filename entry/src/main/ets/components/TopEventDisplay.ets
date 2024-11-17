import router from '@ohos.router';
import { EventList, EventItem } from '../model/EventModel';
import { DayArrowSymbol } from './DayArrowSymbol';


@Component

export struct TopEventDisplay{
        @Prop event: EventItem




        private getDaysDistance(dateStr: string): string{
                let today = new Date(Date.now());
                let eventDate = new Date(dateStr)


                const differenceInTime = today.getTime() - eventDate.getTime();
                console.error("today  " + today.getTime()  +  "   eventDate   " + eventDate.getTime())
                const differenceInDays = Math.floor(differenceInTime / (1000 * 60 * 60 * 24));
                console.error("distance Date  " + differenceInDays)
                return differenceInDays.toString()

        }

        private checkEmptyEvent(value: string): string{
                if(value === ""){
                        return "无事件"
                }
                return value
        }


        build() {
                Column(){
                        DayArrowSymbol({day: Number(this.getDaysDistance(this.event.date)), sizeOfSymbolHeight: "12%", sizeOfSymbolWidth: "8%", sizeOfFont: 80})



                        Text(this.checkEmptyEvent(this.event.title))
                                .fontSize(22)
                                .fontWeight(FontWeight.Bold)
                                .fontColor("#ffffff")


                        Text(("纪念日  "+ this.event.date))
                                .fontSize(14)
                                .fontColor("#ffffff")


                }.width("90%").height("20%")



        }
}