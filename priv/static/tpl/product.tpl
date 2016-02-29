    {{#drinks}}
        <div class="four wide column">
          <div class="ui segment">
            <h3>{{name}}</h3>
            <button data-bind="click: addLine()" class="ui green button">RM {{price}}</button>
          </div>
        </div>    
    {{/drinks}}
    