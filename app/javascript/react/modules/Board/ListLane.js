import React from 'react';
import CardItem from './CardItem';

export default function ListLane({ lists }) {
  return (
    <div className="listWrapper">
      {lists.map((list) => (
        <div className="list" key={list.id}>
          <div className="list_header">
            <h2 className="list_header_title">{list.title}</h2>
            <div className="list_header_action">
              <a
                href={`/list/${list.id}`}
                data-method="delete"
                data-confirm={`Are you sure you want to remove '${list.title}'?`}
              >
                <i className="fas fa-trash" />
              </a>
              <a href={`/list/${list.id}/edit`}>
                <i className="fas fa-pen" />
              </a>
            </div>
          </div>
          <div className="cardWrapper">
            {list.cards?.map((card) => (
              <CardItem key={card.id} listId={list.id} card={card} />
            ))}
            <div className="addCard">
              <i className="far fa-plus-square"></i>
              <a href={`/list/${list.id}/card/new`} className="addCard_link">
                Add a card...
              </a>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}
