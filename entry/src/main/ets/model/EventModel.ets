
export class EventItem {

        public title: string;
        public date: string;
        public repeat: string;
        public tag: string;
        public top: boolean;


        constructor(title: string, date: string, repeat: string, tag: string, top: boolean) {

                this.title = title;
                this.date = date;
                this.repeat = repeat;
                this.tag = tag;
                this.top = top;
        }
}

export const EventList: EventItem[] = [];